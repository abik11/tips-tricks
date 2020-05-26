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

## NSubstitute

### Check if a method with ref parameter was called
With NSubsitute it is possible to check (make an assertion actually) if some method was called. We can specify many details of the call like what should be the arguments, how many a method should be called etc.<br />
It is a little tricky though, if we have to specify some conditions to **ref** parameters. To make it work with NSubstitute we have to first define the condition and save it as a variable and pass this variable to the function instead of passing the condition directly. Here is a very simple example:
```csharp
class ProductRepository
{
    protected IRepository Repository { get; set; }

    public ProductRepository(IRepository repository)
        => Repository = repository;

    public UpdateProductStatus(ref Product product, ProductStatus status)
    {
        product.Status = status;
        Repository.Save(ref product);
    }
}

var product = Arg.Is<Product>(x => x.Code == "P0525");
Repository.Received().Save(ref product);
```

### Rhino Mocks WhenCalled to NSubstitute
Rhino Mocks:
```csharp
var MockRepository.GenerateMock<IRepository>();
repository
    .Stub(r => r.ExecuteWithLogger(Arg<Action<ILogger>>.Is.Anything))
    .WhenCalled(invocation => ((Action<ILogger>)invocation.Arguments[0]).Invoke(logger));
```
NSubstitute
```csharp
var repository = Substitute.For<IRepository>();
repository
    .WhenForAnyArgs(r => r.ExecuteWithLogger(Arg.Any<Action<ILogger>>()))
    .Do(invocation => ((Action<ILogger>)invocation.Args()[0]).Invoke(logger));
```
