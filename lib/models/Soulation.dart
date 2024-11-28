class Solution {
  final int id;
  final List<Issue> issues;
  final String title;
  final String description;
  final List<Tag> tags;
  final bool isPublic;
  final String? imageUrl;

  Solution({
    required this.id,
    required this.issues,
    required this.title,
    required this.description,
    required this.tags,
    required this.isPublic,
    this.imageUrl,
  });

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      id: json['id'],
      issues: (json['issues'] as List)
          .map((issue) => Issue.fromJson(issue))
          .toList(),
      title: json['title'],
      description: json['description'],
      tags: (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList(),
      isPublic: json['is_public'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issues': issues.map((issue) => issue.toJson()).toList(),
      'title': title,
      'description': description,
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'is_public': isPublic,
      'image': imageUrl,
    };
  }
}

class Issue {
  final int id;
  final String name;

  Issue({required this.id, required this.name});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
