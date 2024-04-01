# in main
def main():
    n = input("Enter a number: ")
    print("The result is:", mystery(n))

# Compute mystery equation
def mystery(n):
    if n == 0:
        return 0
    return mystery(n-1) + 2*n - 1
