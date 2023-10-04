import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'developer.dart';
import 'localizations.dart';
import 'permissions.dart';

class AppInfo extends Equatable {
  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AppInfo].
  factory AppInfo.fromJson(String data) {
    return AppInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  factory AppInfo.fromMap(Map<String, dynamic> data) => AppInfo(
        name: data['name'] as String?,
        url: data['URL'] as String?,
        version: data['version'] as String?,
        description: data['description'] as String?,
        developer: data['developer'] == null
            ? null
            : Developer.fromMap(data['developer'] as Map<String, dynamic>),
        permissions: data['permissions'] == null
            ? null
            : Permissions.fromMap(data['permissions'] as Map<String, dynamic>),
        localizations: data['localizations'] == null
            ? null
            : Localizations.fromMap(
                data['localizations'] as Map<String, dynamic>),
        ageRating: data['ageRating'] as String?,
        supportedPlatforms: data['supportedPlatforms'] as List<dynamic>?,
      );

  const AppInfo({
    this.name,
    this.url,
    this.version,
    this.description,
    this.developer,
    this.permissions,
    this.localizations,
    this.ageRating,
    this.supportedPlatforms,
  });
  final String? name;
  final String? url;
  final String? version;
  final String? description;
  final Developer? developer;
  final Permissions? permissions;
  final Localizations? localizations;
  final String? ageRating;
  final List<dynamic>? supportedPlatforms;

  Map<String, dynamic> toMap() => {
        'name': name,
        'URL': url,
        'version': version,
        'description': description,
        'developer': developer?.toMap(),
        'permissions': permissions?.toMap(),
        'localizations': localizations?.toMap(),
        'ageRating': ageRating,
        'supportedPlatforms': supportedPlatforms,
      };

  /// `dart:convert`
  ///
  /// Converts [AppInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  AppInfo copyWith({
    String? name,
    String? url,
    String? version,
    String? description,
    Developer? developer,
    Permissions? permissions,
    Localizations? localizations,
    String? ageRating,
    List<String>? supportedPlatforms,
  }) {
    return AppInfo(
      name: name ?? this.name,
      url: url ?? this.url,
      version: version ?? this.version,
      description: description ?? this.description,
      developer: developer ?? this.developer,
      permissions: permissions ?? this.permissions,
      localizations: localizations ?? this.localizations,
      ageRating: ageRating ?? this.ageRating,
      supportedPlatforms: supportedPlatforms ?? this.supportedPlatforms,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      url,
      version,
      description,
      developer,
      permissions,
      localizations,
      ageRating,
      supportedPlatforms,
    ];
  }
}
