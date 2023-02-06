# YOLOv5 🚀 by Ultralytics, GPL-3.0 license
# Image is CPU-optimized for ONNX, OpenVINO and PyTorch YOLOv5 deployments

FROM ultralytics/yolov5:latest-cpu
COPY . /usr/src/app

RUN pip install --upgrade pip
RUN pip install flask

WORKDIR /usr/src/app
CMD ["python3", "app.py"]