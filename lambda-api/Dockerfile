FROM public.ecr.aws/lambda/python:3.8
COPY .  .
RUN  pip install -r requirements.txt
CMD ["app.lambda_function"]