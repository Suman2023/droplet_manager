import 'dart:convert';


DropletResponse dropletResponseFromJson(String str) => DropletResponse.fromJson(json.decode(str));

String dropletResponseToJson(DropletResponse data) => json.encode(data.toJson());

class DropletResponse {
    Droplet? droplet;
    final DateTime fetchedAt;

    DropletResponse({
        this.droplet,
    }) : fetchedAt = DateTime.now();

    factory DropletResponse.fromJson(Map<String, dynamic> json) => DropletResponse(
        droplet: json["droplet"] == null ? null : Droplet.fromJson(json["droplet"]),
    );

    Map<String, dynamic> toJson() => {
        "droplet": droplet?.toJson(),
    };
}




DropletsResponse dropletsResponseFromJson(String str) =>
    DropletsResponse.fromJson(json.decode(str));

String dropletsResponseToJson(DropletsResponse data) =>
    json.encode(data.toJson());

class DropletsResponse {
  List<Droplet> droplets;
  Links links;
  Meta meta;

  DropletsResponse({
    required this.droplets,
    required this.links,
    required this.meta,
  });

  factory DropletsResponse.fromJson(Map<String, dynamic> json) =>
      DropletsResponse(
        droplets: List<Droplet>.from(
            json["droplets"].map((x) => Droplet.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "droplets": List<dynamic>.from(droplets.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Droplet {
  int? id;
  String? name;
  int? memory;
  int? vcpus;
  int? disk;
  bool? locked;
  String? status;
  dynamic kernel;
  DateTime? createdAt;
  List<String>? features;
  List<int>? backupIds;
  NextBackupWindow? nextBackupWindow;
  List<int>? snapshotIds;
  Image? image;
  List<String>? volumeIds;
  Size? size;
  String? sizeSlug;
  Networks? networks;
  Region? region;
  List<String>? tags;
  String? vpcUuid;

  Droplet({
    this.id,
    this.name,
    this.memory,
    this.vcpus,
    this.disk,
    this.locked,
    this.status,
    this.kernel,
    this.createdAt,
    this.features,
    this.backupIds,
    this.nextBackupWindow,
    this.snapshotIds,
    this.image,
    this.volumeIds,
    this.size,
    this.sizeSlug,
    this.networks,
    this.region,
    this.tags,
    this.vpcUuid,
  });

  factory Droplet.fromJson(Map<String, dynamic> json) => Droplet(
        id: json["id"],
        name: json["name"],
        memory: json["memory"],
        vcpus: json["vcpus"],
        disk: json["disk"],
        locked: json["locked"],
        status: json["status"],
        kernel: json["kernel"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        backupIds: json["backup_ids"] == null
            ? []
            : List<int>.from(json["backup_ids"]!.map((x) => x)),
        nextBackupWindow: json["next_backup_window"] == null
            ? null
            : NextBackupWindow.fromJson(json["next_backup_window"]),
        snapshotIds: json["snapshot_ids"] == null
            ? []
            : List<int>.from(json["snapshot_ids"]!.map((x) => x)),
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        volumeIds: json["volume_ids"] == null
            ? []
            : List<String>.from(json["volume_ids"]!.map((x) => x)),
        size: json["size"] == null ? null : Size.fromJson(json["size"]),
        sizeSlug: json["size_slug"],
        networks: json["networks"] == null
            ? null
            : Networks.fromJson(json["networks"]),
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
        vpcUuid: json["vpc_uuid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "memory": memory,
        "vcpus": vcpus,
        "disk": disk,
        "locked": locked,
        "status": status,
        "kernel": kernel,
        "created_at": createdAt?.toIso8601String(),
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "backup_ids": backupIds == null
            ? []
            : List<dynamic>.from(backupIds!.map((x) => x)),
        "next_backup_window": nextBackupWindow?.toJson(),
        "snapshot_ids": snapshotIds == null
            ? []
            : List<dynamic>.from(snapshotIds!.map((x) => x)),
        "image": image?.toJson(),
        "volume_ids": volumeIds == null
            ? []
            : List<dynamic>.from(volumeIds!.map((x) => x)),
        "size": size?.toJson(),
        "size_slug": sizeSlug,
        "networks": networks?.toJson(),
        "region": region?.toJson(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "vpc_uuid": vpcUuid,
      };
}

class Image {
  int? id;
  String? name;
  String? distribution;
  String? slug;
  bool? public;
  List<String>? regions;
  DateTime? createdAt;
  String? type;
  int? minDiskSize;
  double? sizeGigabytes;
  String? description;
  List<dynamic>? tags;
  String? status;
  String? errorMessage;

  Image({
    this.id,
    this.name,
    this.distribution,
    this.slug,
    this.public,
    this.regions,
    this.createdAt,
    this.type,
    this.minDiskSize,
    this.sizeGigabytes,
    this.description,
    this.tags,
    this.status,
    this.errorMessage,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        name: json["name"],
        distribution: json["distribution"],
        slug: json["slug"],
        public: json["public"],
        regions: json["regions"] == null
            ? []
            : List<String>.from(json["regions"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        type: json["type"],
        minDiskSize: json["min_disk_size"],
        sizeGigabytes: json["size_gigabytes"]?.toDouble(),
        description: json["description"],
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        status: json["status"],
        errorMessage: json["error_message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "distribution": distribution,
        "slug": slug,
        "public": public,
        "regions":
            regions == null ? [] : List<dynamic>.from(regions!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "type": type,
        "min_disk_size": minDiskSize,
        "size_gigabytes": sizeGigabytes,
        "description": description,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "status": status,
        "error_message": errorMessage,
      };
}

class Networks {
  List<V4>? v4;
  List<V6>? v6;

  Networks({
    this.v4,
    this.v6,
  });

  factory Networks.fromJson(Map<String, dynamic> json) => Networks(
        v4: json["v4"] == null
            ? []
            : List<V4>.from(json["v4"]!.map((x) => V4.fromJson(x))),
        v6: json["v6"] == null
            ? []
            : List<V6>.from(json["v6"]!.map((x) => V6.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "v4": v4 == null ? [] : List<dynamic>.from(v4!.map((x) => x.toJson())),
        "v6": v6 == null ? [] : List<dynamic>.from(v6!.map((x) => x.toJson())),
      };
}

class V4 {
  String? ipAddress;
  String? netmask;
  String? gateway;
  String? type;

  V4({
    this.ipAddress,
    this.netmask,
    this.gateway,
    this.type,
  });

  factory V4.fromJson(Map<String, dynamic> json) => V4(
        ipAddress: json["ip_address"],
        netmask: json["netmask"],
        gateway: json["gateway"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "ip_address": ipAddress,
        "netmask": netmask,
        "gateway": gateway,
        "type": type,
      };
}

class V6 {
  String? ipAddress;
  int? netmask;
  String? gateway;
  String? type;

  V6({
    this.ipAddress,
    this.netmask,
    this.gateway,
    this.type,
  });

  factory V6.fromJson(Map<String, dynamic> json) => V6(
        ipAddress: json["ip_address"],
        netmask: json["netmask"],
        gateway: json["gateway"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "ip_address": ipAddress,
        "netmask": netmask,
        "gateway": gateway,
        "type": type,
      };
}

class NextBackupWindow {
  DateTime? start;
  DateTime? end;

  NextBackupWindow({
    this.start,
    this.end,
  });

  factory NextBackupWindow.fromJson(Map<String, dynamic> json) =>
      NextBackupWindow(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}

class Region {
  String? name;
  String? slug;
  List<String>? features;
  bool? available;
  List<String>? sizes;

  Region({
    this.name,
    this.slug,
    this.features,
    this.available,
    this.sizes,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        name: json["name"],
        slug: json["slug"],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        available: json["available"],
        sizes: json["sizes"] == null
            ? []
            : List<String>.from(json["sizes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "available": available,
        "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
      };
}

class Size {
  String? slug;
  int? memory;
  int? vcpus;
  int? disk;
  double? transfer;
  double? priceMonthly;
  double? priceHourly;
  List<String>? regions;
  bool? available;
  String? description;

  Size({
    this.slug,
    this.memory,
    this.vcpus,
    this.disk,
    this.transfer,
    this.priceMonthly,
    this.priceHourly,
    this.regions,
    this.available,
    this.description,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        slug: json["slug"],
        memory: json["memory"],
        vcpus: json["vcpus"],
        disk: json["disk"],
        transfer: json["transfer"],
        priceMonthly: json["price_monthly"],
        priceHourly: json["price_hourly"]?.toDouble(),
        regions: json["regions"] == null
            ? []
            : List<String>.from(json["regions"]!.map((x) => x)),
        available: json["available"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "memory": memory,
        "vcpus": vcpus,
        "disk": disk,
        "transfer": transfer,
        "price_monthly": priceMonthly,
        "price_hourly": priceHourly,
        "regions":
            regions == null ? [] : List<dynamic>.from(regions!.map((x) => x)),
        "available": available,
        "description": description,
      };
}

class Links {
  Pages? pages;

  Links({
    this.pages,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        pages: json["pages"] == null ? null : Pages.fromJson(json["pages"]),
      );

  Map<String, dynamic> toJson() => {
        "pages": pages?.toJson(),
      };
}

class Pages {
  Pages();

  factory Pages.fromJson(Map<String, dynamic> json) => Pages();

  Map<String, dynamic> toJson() => {};
}

class Meta {
  int? total;

  Meta({
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
      };
}

DropletErrorResponse dropletErrorResponseFromJson(String str) =>
    DropletErrorResponse.fromJson(json.decode(str));

String dropletErrorResponseToJson(DropletErrorResponse data) =>
    json.encode(data.toJson());

class DropletErrorResponse {
  String id;
  String message;

  DropletErrorResponse({
    required this.id,
    required this.message,
  });

  factory DropletErrorResponse.fromJson(Map<String, dynamic> json) =>
      DropletErrorResponse(
        id: json["id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
      };
}

DropletActionResponse dropletActionResponseFromJson(String str) =>
    DropletActionResponse.fromJson(json.decode(str));

String dropletActionResponseToJson(DropletActionResponse data) =>
    json.encode(data.toJson());

class DropletActionResponse {
  Action action;

  DropletActionResponse({
    required this.action,
  });

  factory DropletActionResponse.fromJson(Map<String, dynamic> json) =>
      DropletActionResponse(
        action: Action.fromJson(json["action"]),
      );

  Map<String, dynamic> toJson() => {
        "action": action.toJson(),
      };
}

class Action {
  int id;
  String status;
  String type;
  DateTime startedAt;
  DateTime? completedAt;
  int? resourceId;
  String resourceType;

  Action({
    required this.id,
    required this.status,
    required this.type,
    required this.startedAt,
    this.completedAt,
    this.resourceId,
    required this.resourceType,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        id: json["id"],
        status: json["status"],
        type: json["type"],
        startedAt: DateTime.parse(json["started_at"]),
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]),
        resourceId: json["resource_id"],
        resourceType: json["resource_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "type": type,
        "started_at": startedAt.toIso8601String(),
        "completed_at": completedAt?.toIso8601String(),
        "resource_id": resourceId,
        "resource_type": resourceType,
      };
}
