# Demonstrate installing Python in Alpine Linux.
FROM alpine

# Set environment variables(s) all at once; i.e., within a single layer.
ENV NAME="Alpython" VERSION="0.1"

# Add metadata to this image.
LABEL base.version=$VERSION

# Run this container as a non-root user (worker).
RUN addgroup -g 3000 -S worker \
  && adduser -G worker -S worker

# Install Python.
RUN apk update \
  && apk add python

# Execute "python -v" at run time.
CMD ["-v"]
ENTRYPOINT ["python"]
