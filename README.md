# Application Template

This is a template for a microservice application for Tekton based CI/CD

To use this template:

1. Create a copy for your application


		```
		```

2. Edit `tekton/config` for the custom values especially for appname, appversion and apptype. 
Potentially editing any `tekton` resources and `k8s` resources that are needed. 
Commit the configuration in the **master** branch.

3. Run `tekton/init.sh` to load tekton resources and initialize the Web hook for the git repo

4. Create your application on the **dev** branch

5. Commit your **dev** branch when ready; this will trigger deployment to the managed cluster.

 
