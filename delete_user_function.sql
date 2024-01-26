CREATE DEFINER=`root`@`localhost` FUNCTION `vk`.`Delete_user_function`(for_user_id BIGINT UNSIGNED) 
RETURNS bigint
DETERMINISTIC
begin
	set global foreign_key_checks = 0;
	delete from friend_requests 
	where initiator_user_id = for_user_id or target_user_id = for_user_id;
	delete from likes 
	where user_id = for_user_id;
	delete from media 
	where user_id = for_user_id;
	delete from messages 
	where from_user_id = for_user_id or to_user_id = for_user_id;
	delete from profiles 
	where user_id = for_user_id;
	delete from users 
	where id = for_user_id;
	delete from users_communities 
	where user_id = for_user_id;
	set global foreign_key_checks = 1;
	return profiles.user_id = for_user_id;
END