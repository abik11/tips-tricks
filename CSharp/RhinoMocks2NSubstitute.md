# Convert Rhino Mocks to NSubstitute

## Usings
* Rhino
```csharp
using Rhino.Mocks;
```
* NSubstitute
```csharp
using NSubstitute;
```

## Mocking objects
* Rhino
```csharp
var mock = MockRepository.GenerateMock<IUserRepository>();
```
* NSubstitute
```csharp
var mock = Substitute.For<IUserRepository>();
```

## Patrial mocking
* Rhino
```csharp
var mock = MockRepository.GeneratePartialMock<UserRepository>(ConfigurationRepository);
```
* NSubstitute
```csharp
var mock = Substitute.For<UserRepository>(ConfigurationRepository);
```

## Stubbing methods
* Rhino
```csharp
mock.Stub(m => m.IsActive(user)).Return(false);
```
* NSubstitute
```csharp
mock.IsActive(user).Returns(false);
```


## Executing given code instead of stubbed method (for void return type)
* Rhino
```csharp
mock
  .Stub(m => m.AddRole(Arg<Role>.Is.Anything))
  .WhenCalled(invocation =>
  {
    DoSomething(invocation.Arguments[0]);
  });
```
* NSubstitute
```csharp
mock
  .When(x => x.AddRole(Arg.Any<Role>()))
  .Do(x =>
  {
    DoSomething(x.Args()[0]);
  });
```

## Ignoring arguments
* Rhino
```csharp
Arg<User>.Is.Anything
```
* NSubstitute
```csharp
Arg.Any<User>()
```

## Conditionally matching arguments
* Rhino
```csharp
Arg<User>.Is.Null
Arg<IEnumerable<int>>.List.ContainsAll(new[] { 10 })
Arg<int>.Is.Equal(user.Id)
```
* NSubstitute
```csharp
Arg.Is<User>(x => x == null)
Arg.Is<IEnumerable<int>>(x => x.Contains(10))
Arg.Is(user.Id)
```

## Matching ref arguments
* Rhino
```csharp
mock.Save(ref Arg<User>.Ref(Rhino.Mocks.Constraints.Is.Anything(), null).Dummy);
```
* NSubstitute
```csharp
var user = Arg.Any<User>();
mock.Save(ref invoice);
```

## Asserting if a method was called or not
* Rhino
```csharp
mock.AssertWasNotCalled(m => m.IsActive(user));
mock.AssertWasCalled(m => m.IsActive(user));
mock.AssertWasCalled(m => m.IsActive(user), opt => opt.Repeat.Twice());
```
* NSubstitute
```csharp
mock.DidNotRecieve().IsActive(user);
mock.Recieved().IsActive(user);
mock.Recieved(2).IsActive(user);
```

## Asserting if a method was called with specified arguments
* Rhino
```csharp
mock.Expect(x => x.SetCulture(
    Arg.Is(user),
    Arg<ICulture>.Is.Null));

mock.VerifyAllExpectations();
```
* NSubstitute
```csharp
mock.Received().SetCulture(
    Arg.Is(user),
    Arg.Is<ICulture>(x => x == null));
```

* Rhino
```csharp
mock.Expect(x => x.SetCulture(
    Arg.Is(user),
    Arg<ICulture>.Is.Null)).Repeat.Never();

mock.VerifyAllExpectations();
```
* NSubstitute
```csharp
mock.DidNotReceive().SetCulture(
    Arg.Is(user),
    Arg.Is<ICulture>(x => x == null));
```

## Useful links
* https://wrightfully.com/guide-to-nsubstitute-for-rhino-mocks-users
