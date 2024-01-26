CREATE PROCEDURE vk.delete_user_sp(for_user_id BIGINT UNSIGNED)
begin
	declare '_rollback' bool default 0;
	declare code varchar(100);
	declare error_string varchar(100);
	declare delete_user_id int;

	declare continue handler for sqlexception
	begin
		set '_rollback' = 1;
		get stacked diagnostics condition 1
		code = returned_sqltate, error_string = message_text;
		set tran_result := concat('Error occured. Code: ', code, 'Text: ', error_string);
	
	start transaction;
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
		
		if '_rollback' then
			rollback;
		else
			set tran_result := 'ok';
			commit;
		end if;
END