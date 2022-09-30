package main

import (
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"
	"k8s.io/api/policy/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func TestPdbTemplate(t *testing.T) {
	release := "production"

	for _, tc := range []struct {
		CaseName string
		Values   map[string]string

		ExpectedErrorRegexp *regexp.Regexp

		ExpectedName     string
		ExpectedSelector *metav1.LabelSelector
	}{
		{
			CaseName: "selectors",
			Values: map[string]string{
				"application.tier":            "web",
				"application.track":           "stable",
				"podDisruptionBudget.enabled": "true",
			},
			ExpectedName: "production-auto-deploy",
			ExpectedSelector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"app":     "production",
					"release": "production",
					"tier":    "web",
					"track":   "stable",
				},
			},
		},
	} {
		t.Run(tc.CaseName, func(t *testing.T) {
			namespaceName := "minimal-ruby-app-" + strings.ToLower(random.UniqueId())

			values := map[string]string{
				"gitlab.app": "auto-devops-examples/minimal-ruby-app",
				"gitlab.env": "prod",
			}

			mergeStringMap(values, tc.Values)

			options := &helm.Options{
				SetValues:      values,
				KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
			}

			output, err := helm.RenderTemplateE(
				t,
				options,
				helmChartPath,
				release,
				[]string{"templates/pdb.yaml"},
			)

			if tc.ExpectedErrorRegexp != nil {
				require.Regexp(t, tc.ExpectedErrorRegexp, err.Error())
				return
			}

			require.NoError(t, err)

			var podDisruptionBudget v1beta1.PodDisruptionBudget
			helm.UnmarshalK8SYaml(t, output, &podDisruptionBudget)

			require.Equal(t, tc.ExpectedName, podDisruptionBudget.Name)
			require.Equal(t, tc.ExpectedSelector, podDisruptionBudget.Spec.Selector)
		})
	}
}
