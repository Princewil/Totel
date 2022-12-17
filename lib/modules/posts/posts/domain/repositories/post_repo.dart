import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/post_entity.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_booked_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/attachment_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../../create/create_post_functions.dart';

abstract class PostRepo {
  Future<void> createBookedPost(CreateBookedPostParams entity,
      {List<XFile> files = const []});

  Future createFindingPost(FindingPostParams entity);

  Future<List<FindingPostParams>> getAllPosts();

  Future<AttachmentEntity> uploadAttachment(String path, String fileName);
}
