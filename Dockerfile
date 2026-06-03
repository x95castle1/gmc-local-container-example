FROM bellsoft/liberica-openjdk-alpine:17

WORKDIR /opt/gemfire

# Create a non-root system user for security compliance
RUN addgroup -S gemfire && adduser -S gemfire -G gemfire

# Copy the standalone downloaded JAR file into the container
COPY ./gemfire-management-console-1.4.5.jar app.jar

# Ensure the app runtime directory has correct permissions
RUN mkdir -p /opt/gemfire/VMware_GemFire_Management_Console && \
    chown -R gemfire:gemfire /opt/gemfire

USER gemfire

EXPOSE 8080

# CRITICAL JVM FLAGS: Required for Java 17/21 architectures running GMC
ENTRYPOINT ["java", \
            "--add-opens", "java.base/java.lang=ALL-UNNAMED", \
            "--add-opens", "java.base/java.util=ALL-UNNAMED", \
            "--add-opens", "java.base/java.io=ALL-UNNAMED", \
            "-jar", "app.jar"]