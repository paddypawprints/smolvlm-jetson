FROM  smol-base:r36.4.tegra-aarch64-cu126-22.04

# Create a working directory
WORKDIR /app

# Copy any application files (optional)
COPY startup.py /app

# Patch modelling_idefics3.py
COPY modelling_idefics3.jt.py /usr/local/lib/python3.10/dist-packages/transformers/models/idefics3/modeling_idefics3.py 
 
COPY OpenCV-4-12-0.sh /app

RUN bash OpenCV-4-12-0.sh

# Create a non-root user for security
#RUN useradd -m -s /bin/bash appuser
#USER appuser

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]

# Default command (optional - will run if no command provided)
CMD ["-l"]
