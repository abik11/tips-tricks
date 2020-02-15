## Table of contents
* [Linq to XML](#linq-to-xml)
* [XmlDocument class](#xmldocument-class)

## Linq to XML 
* Example XML<br />
This document will be used for the following C# examples: 
```xml
<people>
	<person id="4245323">
		<lastName>Jones</lastName>
		<firstName>Henry</lastName>
		<address>
			<city lang="en">Cracow</city>
			<street>Żeromskiego</street>
			<houseNumber>43</houseNumber>
			<appartmentNumber>10</appartmentNumber>
			<postalCode>31-400</postalCode>
		</address>
		<phoneNumber>555-111-444</phoneNumber>	
	</person>
</people>
```
* Read<br />
There two ways to retrive XML data. You can load XML document as a string and parse it or you can load some XML file like in the example below:
```csharp
XDocument xdoc = new XDocument();
xdoc = XDocument.Load("file.xml");
```
* Get attribute value
```csharp
int id = 4245323;
XElement person = xdoc.Descendants().First(x => x.Attribute("id").Value == id.ToString());
XAttribute personId = person.Attributes().First();
```
Linq to XML allows you to use methods as **Descendants** or **Attributes** for every element. They return, accordingly, the complete list of descendants of the given element or its attribute list. You can use typical Linq methods with such list, like **FirstOrDefault**, **OrderBy**, etc.<br />
You can also set attribute value like this:
```csharp
person.SetAttribute("id", 23234234);
```
There are many other very useful methods in Linq to XML, like **SetValue** and so on!
* Add new element and delete existing element
```csharp
XElement newPerson = 
	new XElement("person", 
		new Attribute("id", 134523),
		new XElement("firstName", "Lucy"),
		new XElement("lastName", "Richards"),
		new XElement("address", 
			new XElement("city", "Smallville"),
			new XElement("street", "Smallville"),
			new XElement("houseNumber", "14")
		)
	);	
xdoc.Element("people").Add(newPerson);  
xdoc.Descendants("person").Where(x => x.Element("lastName").Value == "Henry").Remove();
```
To create new elements you can create new instance of **XElement** class. Its constructor requires the name of the element that is going to be created and its content. As content, the list of other nested **XElement** instances may be given or **Attribute** class instance or simply some literal value (string, integer etc.). 

## XmlDocument class
It is another way to read and manipulate XML in C#. It reads an XML document into memory. A nice thing about it, is that it alows to execute XPath queries against XML document.
* Read 
```csharp
XmlDocument doc = new XmlDocument();
doc.Load("file.xml");
string id = doc.DocumentElement.ChildNodes[0].Attributes["id"].Value;
```
* XPath
```csharp
XmlNodeList phoneNumberNodes = doc.SelectNodes("//person[@id!='34252']/phoneNumber");
XmlNode streetNode = doc.SelectSingleNode("//person[last()]/address/street");
string streetName = streetNode.InnerText;
```
* Add
```csharp
XmlNode person = doc.CreateElement("person");

XmlAttribute id = doc.CreateAttribute("id");
id.Value = 234235;
person.Attributes.Append(id);

XmlNode lastName = doc.CreateElement("lastName");
lastName.InnerText = "Kozak";
person.AppendChild(lastName);

doc.DocumentElement.AppendChild(person);
doc.Save("file.xml");
```
