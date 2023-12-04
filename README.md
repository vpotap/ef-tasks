# Task 1

To run Docker Compose, you need to install the Docker and Docker Compose packages. For better compatibility with Docker, it is recommended to use a Linux environment, especially if using macOS or Windows. In this case, we will use Vagrant with an Ubuntu image and a shell provisioner to install the Docker and Docker Compose packages.

This task is executed on macOS using the Homebrew installer. To set up a virtual machine using Vagrant with VirtualBox on macOS, follow these steps. Ensure that Homebrew is installed on your macOS system. You can install Vagrant with virtualbox  using the following commands:

```bash
brew install vagrant
brew install --cask virtualbox
```

Then, navigate to the project directory and start up the Vagrant environment:

```bash
cd {{project_dir}}/docker-compose
vagrant up
```

After provisioning the Vagrant environment, SSH into the Vagrant machine and navigate to the synced Vagrant directory where all Docker Compose and service configuration files are copied:

```bash
vagrant ssh
cd /vagrant
```

Next, run Docker Compose containers in the background (you can also use the foreground without the `-d` flag for better debugging). You should  use `sudo` with Docker Compose and Docker commands in Vagrant. This can be skipped if the Vagrant user is added to sudoers file during provision:

```bash
sudo docker-compose up -d
```

Now, test services 1 and 2, as well as Nginx endpoints from Vagrant using port mapping and using `curl` with the `-L` or `-I` flags. Some examples. For service 1:

```bash
curl -L localhost:8081/static-response
```

And for service 2:

```bash
curl -I localhost:8082/epicfrog-redirect
```

For more comprehensive testing, exec into third container (which uses both docker networks) and utilizes DNS naming for services. Then execute the following commands:

```bash
sudo docker-compose exec curl-service sh
curl -L http://nginx-service-2/local-redirect/static-response
```

Additionally, you can automatically sync the folder from macOS to the Vagrant machine for testing Docker Compose changes. Of course, you need to restart Docker Compose every time. To enable automatic syncing, run the following command in the project directory:

```bash
vagrant rsync-auto
```

To stop resources use
```bash
vagrant destroy
```


# Task 2

For the second task, the test environment selected is macOS with Minikube installation. Follow the steps below to set up the environment:

1. **Install QEMU Emulator:**
   ```bash
   brew install qemu
   ```

2. **Start the socket_vmnet service:**
   ```bash
   brew install socket_vmnet
   brew tap homebrew/services
   HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet
   ```

3. **Install Minikube:**
   Follow the instructions from [Minikube Documentation](https://minikube.sigs.k8s.io/docs/start/). In this case, run the following commands:
   ```bash
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
   sudo install minikube-darwin-amd64 /usr/local/bin/minikube
   ```

4. **Install kubectl:**
   ```bash
   brew install kubectl
   ```

5. **Set up an alias for kubectl (optional):**
   ```bash
   alias k='kubectl'
   ```

6. **Start Minikube:**
   Start Minikube using QEMU, socket_vmnet, and set resource limitations according to your environment. Note that the Zookeeper task requires more resources(possible can use multiple nodes and more ram and cpu):
   ```bash
   minikube start --driver qemu --network socket_vmnet --memory 4000mb --cpus 4 --disk-size 8000mb
   ```

7. **Enable metrics-server addon:**
   ```bash
   minikube addons enable metrics-server
   ```

8. **Switch to the project directory and run Terraform commands:**
   ```bash
   cd {{project_dir}}/k8s
   terraform init
   terraform plan
   terraform apply
   ```

9. **Verify resources:**
   ```bash
   k get all
   ```

10. **Delete resources:**
   ```bash
   terraform destroy
   ```   
   
11. **To stop and delete minikube use:**
   ```bash
   minikube stop
   minikube delete
   ```

Some additional notes about sub-tasks:

1. **Nginx Deployment:**
   - A service is created for the Nginx deployment. Access it from Minikube using the command:
     ```bash
     minikube service nginx-minikube-service --url
     ```
   - Other services can be accessed using a similar approach.
   - For testing HPA, use the following commands:
     ```bash
     kubectl run -it --rm load-generator --image=busybox /bin/sh
     while true; do wget -q -O- http://nginx-minikube-service; done
     ```
     Check HPA size using:
     ```bash
     kubectl get hpa -w
     ```

   - nginx-hpa-v2.yml with autoscaling/v2 is created but not used, just showcase.

2. **Zookeper Helm:**
  - Discover Minikube storageClass used for storageClass configuration
    ```bash
    k get sc
    ```
  - need wait to deploy or increase minikube resources  

3. **Redis Deployment:**
   - Added a Kubernetes ConfigMap for configuration.
   - LivenessProbe and ReadinessProbe are added.
   - For production, consider using Helm.

4. **Binary File Encryption/Decryption Showcase:**
   - A Kubernetes Secret is added with a key.
   - An init container creates binary random files on a shared volume.
   - Container 1 encrypts the random file using OpenSSL and the symmetric key from the Secret.
   - Container 2 decrypts the file using OpenSSL and the same Secret key, then compares it with the original random file.
   - "sleep infinity" is added for showcase purposes.
   - To check results, list all pods and select the correct pod:
     ```bash
     k get po
     k exec -it multi-container-6fbf87ddd4-rttgh -c decryption-container -- /bin/sh
     cd shared-data/
     ```

**Note:** These deployments are for showcase purposes and are not intended for production use. Additionally, if there are not enough Minikube resources available, Minikube becomes unstable. In such cases, it is advisable to run only Zookeeper without the other deployments from the tasks. It is also possible to run Minikube with multiple nodes using the command:
 ```bash
 minikube start --nodes 2
 ```