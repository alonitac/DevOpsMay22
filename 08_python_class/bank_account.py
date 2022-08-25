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
    def __init__(self, name, balance):
        self.owner = name
        self.balance = balance

    def deposit(self, deposit):
        self.balance += deposit
        print (">> Deposit Accepted. New balance is : " + str(self.balance))

    def withdraw(self, withdraw):
        if withdraw > self.balance:
            print ("Funds Unavailable!")
        else :
            self.balance -= withdraw
            print (">> Withdrawal Accepted. New balance is : " + str(self.balance))

    def __str__ (self) :
        return f">> Account owner: {self.owner} \n>> Account balance: {self.balance}"

    def __add__(self , other):
        new =  Account(self.owner + ' and ' + other.owner ,self.balance + other.balance)
        self.balance = 0
        other.balance = 0
        return new

if __name__ == '__main__':
    # 1. Instantiate the class
    acct1 = Account('Jose', 100)
    acct2 = Account('Moshe',200)
    #acct3 = Account('Kuky', 4000)

    # 2. Print the object
    print(acct1)
    print(acct2)
    acct3 = acct1+acct2
    print(acct3)
    print(acct1)
    print(acct2)
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
