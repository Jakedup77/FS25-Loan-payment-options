-- farming_simulator_25_loan.lua

-- Configuration (Adjust these values)
local loanAmount = 50000        -- Initial loan amount
local interestRate = 0.05       -- Annual interest rate (5%)
local repaymentPeriod = 12      -- Repayment period in months
local monthlyPayment = 0       -- Calculated monthly payment

-- Script variables
local loanBalance = 0
local monthsRemaining = 0

-- Function to calculate the monthly payment
local function calculateMonthlyPayment()
    local monthlyInterestRate = interestRate / 12
    monthlyPayment = (loanBalance * monthlyInterestRate * (1 + monthlyInterestRate)^monthsRemaining) / ((1 + monthlyInterestRate)^monthsRemaining - 1)
    if math.isNaN(monthlyPayment) then -- Handles edge case where loanBalance is 0
        monthlyPayment = 0
    end
end

-- Function to take out a loan
local function takeLoan(amount)
    if loanBalance == 0 then -- Only allow one loan at a time
        loanBalance = amount
        monthsRemaining = repaymentPeriod
        calculateMonthlyPayment()
        print("Loan of $" .. loanBalance .. " taken. Monthly payment: $" .. string.format("%.2f", monthlyPayment))
        return true
    else
        print("You already have an outstanding loan.")
        return false
    end
end

-- Function to make a payment
local function makePayment(amount)
    if loanBalance > 0 then
        if amount >= monthlyPayment then
            loanBalance = loanBalance - amount
            monthsRemaining = monthsRemaining - 1
            print("Payment of $" .. amount .. " made. Remaining balance: $" .. string.format("%.2f", loanBalance))
            if loanBalance <= 0 then
                loanBalance = 0
                monthsRemaining = 0
                monthlyPayment = 0
                print("Loan fully repaid!")
            end
            calculateMonthlyPayment() -- Recalculate monthly payment if the loan is paid off early.
            return true
        else
            print("Payment must be at least the monthly payment of $" .. string.format("%.2f", monthlyPayment))
            return false
        end
    else
        print("No outstanding loan to pay.")
        return false
    end
end

-- Example usage (You'll need to integrate this into your game's logic)

-- Take out a loan (Example call from a menu or trigger)
if takeLoan(loanAmount) then
  -- Loan was successful
else
    -- Loan failed (already has a loan)
end

-- Make a payment (Example call from a menu or automatically at the end of each game month)
if makePayment(monthlyPayment) then -- Or makePayment(someAmount), if allowing overpayments.
    -- Payment was successful
else
    -- Payment failed (no loan, or insufficient funds)
end

-- Get the current loan balance
local currentBalance = loanBalance
print("Current balance: $" .. string.format("%.2f",currentBalance))

-- Get the current monthly payment
local currentMonthlyPayment = monthlyPayment
print("Current monthly payment: $" .. string.format("%.2f",currentMonthlyPayment))

-- Get the remaining months
local currentMonthsRemaining = monthsRemaining
print("Remaining months: " .. currentMonthsRemaining)

-- You can also add functions to:
-- * Display loan information in a HUD.
-- * Charge interest automatically each game month.
-- * Handle loan defaults.

return {
    takeLoan = takeLoan,
    makePayment = makePayment,
    loanBalance = loanBalance,
    monthlyPayment = monthlyPayment,
    monthsRemaining = monthsRemaining
}
