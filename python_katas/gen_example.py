def my_db():
    # simulate a db. max of 1000 row can be read at once
    pages = [
        [1] * 1000,
        [1] * 1000,
        [1] * 1000,
        [1] * 1000,
        [1] * 1000
    ]
    for page in pages:
        for row in page:
            yield row


if __name__ == '__main__':
    for row in my_db():
        pass