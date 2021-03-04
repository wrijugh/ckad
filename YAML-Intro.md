# YAML - An Introduction

### *by Wriju Ghosh ([@wrijugh](http://twitter.com/wrijugh))*

## Introduction

When I started my career 20 years ago during 2000-2001, XML was the dark horse. My mentor suggested me to pick it up and learn about it. I bought a book on XSLT and even implemented it in a mail body formatting where data was coming from an XML output produced from database. Back then also WebServices and SOA was popular, and the output was always XML.

Things are different from JSON. It has replaced XML in most of the areas. The REST Api and JSON are now integrated. So in many setting which otherwise was commonly being done by XML.

XML and JSON both have solved the purposes they were meant for. However there is a small problem though that both are not that human eye friendly. So, there was a need to come up with something which is compatible with JSON and human readable. Thus, **YAML** was introduced.

As the official YAML documentation says,

> *YAML™ (rhymes with “camel”) is a human-friendly, cross language, Unicode based data serialization language designed around the common native data types of agile programming languages. It is broadly useful for programming needs ranging from configuration files to Internet messaging to object persistence to data auditing. Together with the Unicode standard for characters, this specification provides all the information necessary to understand YAML Version 1.2 and to create programs that process YAML information.*

***YAML is a serialization language***

YAML is used in Kubernetes, Docker, DevOps etc.

Here we will talk about some of the basic syntax of **YAML**

### Key-value

YAML is a key-value combination separated by : and space. YAML uses line separation and spaces.

> YAML don't like tabs use 2 or 3 spaces. Some system like Kubernetes complains if tabs are used for indentation

```yaml
class: III
```

Yaml is hierarchical, hence it can have child elements with indentation (use space not the tab)

```yaml
class: III
  studentName: Wrishika Ghosh
```

### Supported Types

YAML supports primitive types like `string`, `int`, `datetime` etc.

#### **boolean**

```yaml
cleared: true 
deployed: yes
vmStatus: on
```

> Both `yes`,`true`,'`on` are the same. They mean `1`. Any of the three pairs can be used here, `yes-no`, `on-off`, `true-false`.

#### **string**

For string you may or may not use `"` or `'` to wrap it around. If you have special characters like `"` then you need to wrap it around with `'`. In normal course YAML does not enforce you to use quotes for string types.

```yaml
greetings:
- "Hello Mr. Ghosh, good morning"
- Hi
- "Good afternoon Midnight's children"
- "Line 1 \n Line 2"
```

### Comments

You can use `#` to add comments in a YAML

```yaml
# This is YAML file 
class: III
students:       # List of students
- name: Wriju
```

### List of Objects

If you have more than one students to store then use `-`

```yaml
class: III
- studentName: Wrishika Ghosh
- studentName: Wriju Ghosh
```

Because it is higherarchical we can format it better as below.

```yaml
class: III
  students:
  - name: Wrishika
    roleNumber: 1
  - name: Wriju
    roleNumber: 2
```  

Notice here I have both `name` and `roleNumber` together as a single child element within `students`.
> if there is an array then it can be used with - and a space. - can be in the same position at the next line under which the child element is created. You can even give spaces but need to follow the same for next element.
> Use plural like `students` to indicate that it can be an array with one or more elements.

If an array is of same primitive type say `string` then it can be represented in `[]`

```yaml
subjects: ["English", "Kannada", "Mathematics", "Social Science", "History"]
```

This is convenient than writing like below,

```yaml
subjects:
- name: English
- name: Kannada
...
```

### Multiline Strings

By using `|` (pipe) you can enter multiple lines and the line breaks will be preserved in the final output.

```yaml
commentsMultiline: |
    this is comment number one
    There is another good product.
    Perfect.
```

In YAML you can have thing in multiline but read as a single line. Then use `>`

```yaml
commentSingleLine: > 
    Though it is written in multiple lines 
    which helps read the content.
    but actually this is a single line comment.
```

### Multiple YAMLs in a single file

By using `---` (three dashes) you can add multiple YAMLs in a single file

```yaml
class: III
students: ["Wriju", "Wrishika"]
---
school:
  name: Tech School
  address: Virtual
```

### Placeholder

You can use `{{}}` in YAML to create a placeholder. This is used in ***Helm*** a lot.

Hope this was helpful to start.

*Happy YAMLing*
