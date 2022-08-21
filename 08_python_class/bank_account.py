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

    def __init__(self, owner, balance):
        self.owner = owner
        self.balance = balance
    def __len__(self):
        return self.balance

    def __str__(self):
        return f'Account owner: {self.owner}\nAccount balance: {self.balance}$'

    def deposit(self, balance):
        self.balance += balance
        print(f'Deposit accepted your current Balance is: {self.balance}$')

    def withdraw(self, subtract):
        if self.balance >= subtract:
            self.balance -= subtract
            print(f"Withdrawal Accepted  your current balance is: {self.balance}$")

        elif self.balance < subtract:
            print(f"Funds Unavailable\n"
                  f"your current Balance is: {self.balance}$"
                  f"\nin order to withdrawal this amount you need {subtract - self.balance}$")


if __name__ == '__main__':
    # 1. Instantiate the class
    acct1 = Account('Jose', 100)
    acct2 = Account('Jane', 1000)

    # acct3 = acct1 + acct2  # acct1.__add__(acct2)

    # print(len(acct1))
    x = str(acct1)

    # 2. Print the object
    print(acct1)
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
    print()
    # 6. Make a withdrawal that exceeds the available balance
    acct1.withdraw(500)
    # Funds Unavailable!
