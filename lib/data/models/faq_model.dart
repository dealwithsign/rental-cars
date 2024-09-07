import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ItemModel extends Equatable {
  final bool expanded;
  final String headerItem;
  final String discription;
  final Color colorsItem;
  final String img;

  const ItemModel({
    this.expanded = false,
    required this.headerItem,
    required this.discription,
    required this.colorsItem,
    required this.img,
  });

  @override
  List<Object?> get props =>
      [expanded, headerItem, discription, colorsItem, img];
}
