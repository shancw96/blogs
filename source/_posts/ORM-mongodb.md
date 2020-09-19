---
title: deno mongodb ORM
categories: [deno]
tags: []
toc: true
date:
---

## connect to database

```js
const db = new Database("mongo", {
  uri: uri,
  database: dbName,
});

await db.link([FileModel]); // create model for db
```

## db model

```js
import { DataTypes, Model } from "../../deps.ts";
// more field description see: https://eveningkid.github.io/denodb-docs/docs/api/field-descriptors
class File extends Model {
  // table name
  static table = "files";
  // timestamp
  static timestamps = true;

  // dataInfos
  static fields = {
    // define mode1
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
    },
    // define model2
    name: DataTypes.STRING,
    path: DataTypes.STRING,
    fileType: DataTypes.STRING,
  };
  //set default values
  static defaults = {
    name: "unnamed",
  };
}

export default File;
```
