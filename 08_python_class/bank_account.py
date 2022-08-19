"""
Create a bank account class that has two attributes:

* owner
* balance

and two methods:

* deposit
* withdraw

As an added requirement, withdrawals may not exceed the available balance.
Instantiate your class, make several deposits and withdrawals, and test to make sure the account can't be overdrawn.
"""


class Account:
    def __init__(self, name, balance=0):
        self.owner = name
        self.balance = balance
    def deposit(self,money):
        self.balance += money
        print("Deposit Accepted")

    def withdraw(self,money):
        if money > self.balance:
            print("Withdrawals may not exceed the available balance")
        else:
            self.balance -= money
            print("Withdrawal Accepted")

if __name__ == '__main__':

    # 1. Instantiate the class
    acct1 = Account('Jose', 100)


    # 2. Print the object
    print(f"Account owner: {acct1.owner}\nAccount balance: {acct1.balance}")
    # output:
    # >> Account owner:   Jose
    # >> Account balance: $100

    # 3. Show the account owner attribute
    print(acct1.owner)
    # >> 'Jose'

    # 4. Show the account balance attribute
    print(acct1.balance)
    # >> 100

    # 5. Make a series of deposits and withdrawals
    acct1.deposit(50)
    # >> Deposit Accepted

    acct1.withdraw(75)
    # Withdrawal Accepted

    # 6. Make a withdrawal that exceeds the available balance
    acct1.withdraw(500)
    # Funds Unavailable!


