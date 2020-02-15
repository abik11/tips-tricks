## NUnit

### Parametrized unit test with lambda expressions
If you've got a function that takes an `Expression` as an argument and you want to test it against many test cases the best way is to use `TestCaseSource`. Here you can see an example of a positive and negative tests for *ExtractPropertyPath* function:
```csharp
[TestCaseSource(nameof(PositiveCases))]
public void ShouldReturnPropertyPath((Expression<Func<PurchaseOrder, object>> Expr, string Result) testCase)
    => Assert.That(ExtractPropertyPath(testCase.Expr), Is.EqualTo(testCase.Result));

private static readonly (Expression<Func<PurchaseOrder, object>> Expr, string Result)[] PositiveCases =
{
    (po => po.Item.Code, "Item.Code"),
    (po => po.Supplier, "Supplier")
};

[TestCaseSource(nameof(NegativeCases))]
public void ShouldThrowArgumentException_WhenGivenExpressionIsNotPropertyAccess(Expression<Func<PurchaseOrder, object>> propertyExpr)
    => Assert.That(ExtractPropertyPath(propertyExpr), Throws.ArgumentException);

private static readonly Expression<Func<Invoice, object>>[] NegativeCases =
{
    po => po.ToString(),
    po => po.Item.Code.ToString(),
    po => po.Supplier.GetCompany(),
    po => po.Supplier.GetCompany().Id,
    po => new PurchaseOrder(),
    po => po
};
```
