## Linq

## Table of contents
* [Syntax](#syntax)
* [Linq to SQL](#linq-to-sql)

## Syntax

### Linq statements and functions
* **Take, Skip and Orderby** - Allow to modify the final collection<br />
Take(int), TakeWhile(x => x.property == value)<br />
Skip(int), Skip(x => x.property == value)<br />
OrderBy, ThenBy, OrderByDescending, ThenByDescending, Reverse
* **Set operations**<br />
Concat, Union, Distinct, Intersect, Except
* **Types** - Linq allows to get items from a collection of a selected type and also cast items<br />
ToArray, ToList, ToDictionary
```csharp
input.OfType<string>();
input.Cast<string>();
```
* **Single items**<br />
First, FirstOrDefault, Last, LastOrDefault,<br />
Single, SingleOrDefault, ElementAt, ElementAtOrDefault<br />
DefaultIfEmpty
* **Quantifiers**<br />
Contains, Any(x => condition), All(x => condition), SequenceEqual
* **Generators** - Allow to generate collection.
```csharp
Enumerable.Empty<Employee>();
Enumerable.Range(5, 8);
Enumerable.Repeat("a", 10);
```

##### FirstOrDefault vs. SingleOrDefault
**FirstOrDefault** returns the first element of given collection no matter how many items it contains while **SingleOrDefault** will throw an exception if given collection will contain more than one item, otherwise it will return this single item.

### Best practices and common mistakes
* Check if any item exists in a collection
```csharp
if(dataCollection.Any()){ ... } // + GOOD
if(dataCollection.Count() > 0){ ... } // - BAD
```
* Order by more than one property
```csharp
dataCollection.OrderBy(x => x.name).ThenBy(x => x.age); // + GOOD
dataCollection.OrderBy(x => x.name).OrderBy(x => x.age); // - BAD
```
* Count big amount of data
```csharp
dataCollection.CountLong; // + GOOD
dataCollection.Count; // - BAD
```

#### Value cannot be null - parameter name: source
If you have a piece of code like this - any Linq method called on `IQueryable` instance:
```csharp
session.Query<Product>().Where(p => p.Price > 10);
```
and it throws the exception:
```
System.ArgumentNullException : Value cannot be null.
Parameter name: source
```
it might mean that the expressions before Linq methods returned `null` and you cannot call Linq method on a null object.

### Group by multiple columns
```csharp
var result =
    from pp in productionPlanData
    group pp by new 
    {
        pp.ProductionLine,
	pp.ProductionStartHour
    }
    into groupedPlan
    select new GroupedPlan 
    {
        Line = groupedPlan.Key.ProductionLine,
	Hour = groupedPlan.Key.ProductionStartHour,
	PlanItems = groupedPlan.ToList()
    };
```

### Join
Here we've got very simple example. There are two structures, one with recipes and other with reviews. What we want to achieve is to get as a result a list of recipes toegether with their reviews. So here is how we do that:
```csharp
Recipe[] recipes = 
{
   new Recipe {Id = 1, Name = "Mashed Potato"},
   new Recipe {Id = 2, Name = "Crispy Duck"},
   new Recipe {Id = 3, Name = "Sachertorte"}
};
Review[] reviews = 
{
   new Review {RecipeId = 1, ReviewText = "Tasty!"},
   new Review {RecipeId = 1, ReviewText = "Not nice :("},
   new Review {RecipeId = 1, ReviewText = "Pretty good"},
   new Review {RecipeId = 2, ReviewText = "Too hard"},
   new Review {RecipeId = 2, ReviewText = "Loved it"}
};

var query = 
    from recipe in recipes
    join review in reviews 
    on recipe.Id equals review.RecipeId
    select new 
    {
        RecipeName = recipe.Name,
        RecipeReview = review.ReviewText
    };
```

### Multiple join condintions
It is often required to specify more than one join conditions and it is very easy to do with Linq, here is an example of the syntax:
```csharp
var data = 
   from x1 in d1
   join y1 in d2
   on new { A = x1.Prop1, B = x1.Prop2 } equals new { A = y1.P1, B = y1.P2 }
   select new 
   {
      Name = y1.Name,
      Quantity = x1.Qty
   }
```
A very important thing to remember is that the names of properties of the anonymous objects for the join conditions must have exactly the same names, otherwise an exeception will be thrown.

### Use delegate to define where clauses
Using delegates of type **Func<T, bool>** is a smooth way to change the **where** clause in the runtime depending on given condition. See an example:
```csharp
IEnumerable<Student> GetBestStudents()
{
	Func<Student, bool> isGoodStudent = s => s.Grade > 4;
	return GetStudents(isGoodStudent).OrderByDescending(s => s.Grade).Take(10);
}

IEnumerable<Student> GetWorstStudents()
{
	Func<Student, bool> isBadStudent = s => s.Grade < 3;
	return GetStudents(isBadStudent).OrderBy(s => s.Grade).Take(10);
}

IEnumerable<Student> GetStudents(Func<Student, bool> where)
{
	return _uow.Query<Student>().Where(where);
}
```
The above example is totally correct but one thing could be done a lot better. In this form, the **Where** method inside of the *GetStudents* will return **IEnumerable** instead of **IQueryable**. In some cases it is acceptable or even desired but here it would be much better to get the **IQueryable** because there are other Linq operation performed on the result of *GetStudents* method, **OrderBy** and **Take**. **OrderBy** and **Take** will work on the whole collection of students that are good or bad which is unnecessary because we only want to get 10 students - **Take(10)**. If *GetStudents* would return **IQueryable** an SQL query would be generated and executed and it would be much faster here. 
There is **no** override of **Where** method that takes **Func<T, bool>** and returns **IQueryable**. An parameter of type **Expression<Func<T, bool>>** must be passed instead, so in general the change to the above code is not too big and finally it should look like this:
```csharp
IEnumerable<Student> GetBestStudents()
{
	Expression<Func<Student, bool>> isGoodStudent = s => s.Grade > 4;
	return GetStudents(isGoodStudent).OrderByDescending(s => s.Grade).Take(10);
}

IEnumerable<Student> GetWorstStudents()
{
	Expression<Func<Student, bool>> isBadStudent = s => s.Grade < 3;
	return GetStudents(isBadStudent).OrderBy(s => s.Grade).Take(10);
}

IEnumerable<Student> GetStudents(Expression<Func<Student, bool>> where)
{
	return _uow.Query<Student>().Where(where);
}
```

## Linq to SQL

### Create Linq to SQL domain project
->Right click on project (Class Library) ->Add New Item ->Data ->**Linq to SQL Classes**<br />
->Server Explorer ->Right click on Data Conections ->Add Connection<br /> 
->Drag and drop tables that you want import and rebuild project from your new connection<br />
Example usage in the code:
```csharp
TestDBDataContext dc = new TestDBDataContext ();
List<Customer> customers = dc.Customers.ToList();
Customer customer = dc.Customers.FirstOrDefault();
dc.Customers.DeleteOnSubmit(customer); //there is also InsertOnSubmit
```

### Change connection string in Linq to SQL
->Open .dbml file ->Properties ->Connection

### Stored procedures in Linq to SQL
->Server Explorer ->Connection ->Select your sever ->Stored Procedures ->Drag procedures to the window next to the model schema
Example usage in the code:
```csharp
TestDBDataContext dc = new TestDBDataContext ();
List<SomeStoredProcedureResult> results = dc.SomeStroredProcedure();
```
