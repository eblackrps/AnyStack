# Required GitHub Repository Secrets

| Secret Name         | Used In                    | Description                        |
|---------------------|----------------------------|------------------------------------|
| PSGALLERY_API_KEY   | workflows/publish.yml      | NuGet API key from powershellgallery.com |

## How to Add Secrets
GitHub repo → Settings → Secrets and variables → Actions → New repository secret

## Rotating Secrets
PSGallery API keys should be rotated annually. After rotation, update the
GitHub secret and verify the publish workflow succeeds on next tag push.
 

