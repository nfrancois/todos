// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library clientserver.model;

import 'package:gcloud/db.dart';

@Kind()
class Item extends Model {
  @StringProperty()
  String name;
  @BoolProperty()
  bool done;
  
  Item();
  
  Item.fromName(this.name){
    done = false;
  }
  
  Map serialize() => {'name': name, 'done': done};

  static Item deserialize(Map json) => new Item()..name = json['name']
                                                 ..done = json['done'];
}
