// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gcloud/db.dart';
import 'package:appengine/appengine.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_appengine/shelf_appengine.dart';
import 'package:shelf_route/shelf_route.dart';
import 'package:uri/uri.dart';

import 'package:todos/model.dart';

Key get itemsRoot => context.services.db.emptyKey.append(Item, id: 1);

Future<List<Item>> queryItems() {
  var query = context.services.db.query(
      Item, ancestorKey: itemsRoot)..order('name');
  return query.run().toList();
}

final itemsUrl = new UriParser(new UriTemplate('/items'));
final cleanUrl = new UriParser(new UriTemplate('/clean'));

void main() {

  var routes = router()
        ..get(itemsUrl, (request){
          return queryItems()
              .then((items) { 
                var result = items.map((item) => item.serialize()).toList();
                var json = {'success': true, 'result': result};
                return new Response.ok(JSON.encode(json));
            });
                
        })
        ..post(itemsUrl, (Request request){
            return request.readAsString().then((body) {
              var json = JSON.decode(body);
              var item = Item.deserialize(json)..parentKey = itemsRoot;
              return context.services.db.commit(inserts: [item]).then((_) {
                  json = {'success': true};
                  return new Response.ok(JSON.encode(json));
                });
            });
        })
        ..get(cleanUrl, (request){
            return queryItems().then((items) {
              var deletes = items.map((item) => item.key).toList();
              return context.services.db.commit(deletes: deletes);
            }).then((_) => new Response.found("/"));
        });
   
  var cascade = new Cascade()
        .add(routes.handler)
        .add(assetHandler(directoryIndexServeMode: DirectoryIndexServeMode.REDIRECT));
  
  serve(cascade.handler);
  
}
