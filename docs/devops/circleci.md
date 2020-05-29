## CircleCI 

Documents our CircleCI setup

### Overview

CircleCI is our _continuous integration tool_, we use it to run tests on our PR's and run automated deployment to certain environments.

#### Docker Images

##### CCI Primary

We make use of a primary custom docker image to serve as the environment for running our test & deployment jobs. We install the software & apply any configuration needed, so that it is only done once and not every time the tests are run.

The image is defined in .circleci/images/Dockerfile, is built locally and pushed to DockerHub. CircleCI then pulls it down for use. There is no automated build pipeline for the image as it is updated infrequently. This Image is stored in DockerHub as `awsdiverst/cci-primary:0.0.<x>`

##### Updating CCI Primary

To update the CCI Primary image, edit the Dockerfile & then run the follow commands. The docker daemon must be running and the commands run as sudo unless you have configured things otherwise. Credentials for the Diverst docker account can be found in our password manager.

Login to docker

```
docker login --username=<username> --password=<password>
```

Build the image with a new version tag

```
docker build -t awsdiverst/cci-primary:0.0.<x> ./
```

Push the new image

```
docker push awsdiverst/cci-primary:0.0.<x>
```
