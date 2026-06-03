# Tanzu GemFire Management Console (GMC) - Docker Deployment Guide

This repository contains the configuration files required to run the VMware Tanzu GemFire Management Console (GMC) version 1.4.1 inside a Docker container using a centralized `application.properties` configuration file.

## Prerequisites

Before deploying the console, ensure you have the following requirements met:

1. **Docker and Docker Compose**: Installed and running on your host machine.
2. **Broadcom Registry Credentials**: Because GMC is hosted on Broadcom's private package registry, you must authenticate your local Docker daemon before pulling the image.

   To authenticate, log into the [Broadcom Customer Support Portal](https://support.broadcom.com), navigate to **My Downloads**, click **Registry Tokens**, and copy your token. Then execute:
```bash
   docker login registry.packages.broadcom.com
```

3. **Pull the GMC Docker Image**: Once authenticated, pull the GMC image from Broadcom's registry. This downloads the pre-built management console image to your local machine so it's available for Docker Compose or standalone use.

```bash
   docker pull registry.packages.broadcom.com/gemfire-management-console/gemfire-management-console:1.4.5
```
