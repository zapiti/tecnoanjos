import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';

Widget builderInfinityListViewComponent(ResponsePaginated response,
    {Function callMoreElements, Function buildBody, Function headerWidget,String errorResponse ,String  emptyMessage}) {
  return ListView.builder(
      padding: EdgeInsets.only(bottom: (response?.last ?? true) ? 80 : 0),
      reverse: false,
      itemCount: response.content.length + 1,
      itemBuilder: (context, index) {
        if (index < (response.content.length ?? 0)) {
          return Flex(direction: Axis.vertical, children: [
            headerWidget != null && index == 0 ? headerWidget() : SizedBox(),
            buildBody(response.content[index])
          ]);
        } else {
          if (response.content.length >= 1) {
            var _page = (response?.number ?? 0) + 1;
            if (!(response?.last ?? true) &&
                response.numberOfElements > 0 &&
                response.totalpages != _page) {
              callMoreElements(_page);
              return loadElements(context, size: 80);
            } else {
              return SizedBox();
            }
          } else {
            return Container();
          }
        }
      });
}

GridView builderInfinityGridViewComponent(
    BuildContext context, ResponsePaginated response,
    {Function callMoreElements, Function buildBody}) {
  double cardWidth = MediaQuery.of(context).size.width / 3.3;
  double cardHeight = 150;
  return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: cardWidth / cardHeight,
      ),
      padding: EdgeInsets.only(bottom: response.last ? 80 : 0),
      reverse: false,
      itemCount: response.content.length + 1,
      itemBuilder: (context, index) {
        if (index < (response.content.length ?? 0)) {
          return buildBody(response.content[index]);
        } else {
          if (response.content.length >= 1) {
            var _page = response?.number ?? 0 + 1;
            if (!response.last &&
                response.numberOfElements > 0 &&
                response.totalpages != _page) {
              callMoreElements(_page);
              return loadElements(context, size: 80);
            } else {
              return SizedBox();
            }
          } else {
            return Container();
          }
        }
      });
}
