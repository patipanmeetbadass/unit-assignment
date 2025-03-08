# src
- contains application source code

# Dockerfile
- Dockerfile to build nodeJS docker image
- Multi stage Dockerfile to reduce image size

# version.txt
- contains the current SemVer number
- Used for anothrNick/github-tag-action@1.71.0 in .github/workflows/bump-version-on-merge.yaml

# .github/workflows/bump-version-on-merge.yaml
- Automatically bump and tag main, on merge, with the latest SemVer formatted version such as v1.0.3-beta.5
- This workflow will be triggered when PR to main branch is merged
- Use anothrNick/github-tag-action@1.71.0 for bump semantic version and tagging the repository
- Set default bump version to patch and 'v' char. as a tag prefix
- So, tag will increases as v1.0.3-beta.5, v1.0.3-beta.6, v1.0.3-beta.7 and so on

# .github/workflows/build-and-push.yaml
- This workflow will be triggered after tagging 'main' branch with prefix 'v' is done
- After check out, step 'Get Tag' will get the latest git tag of the repository to taggin docker image
- Step 'Get ECR repo name', get ECR repository name which is corresponding to the repository name storing this workflow
- Step 'ECR login', login to ECR with AWS account ID 12-digit which is kept in a secret
- Step 'Build and push', build docker image with the latest tag of the repository and push to ECR

# Instructions
- Manually create and merge PR from any branches to branch 'main'
- .github/workflows/bump-version-on-merge.yaml -> Bump version of branch 'main'
- .github/workflows/trigger-on-tag-main.yaml -> Build image with the latest tag of branch 'main' and push to ECR