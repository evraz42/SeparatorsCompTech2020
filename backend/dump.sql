create schema public;

comment on schema public is 'standard public schema';

alter schema public owner to postgres;

create table devices
(
	id_device uuid not null
		constraint devices_pk
			primary key,
	name_device text not null,
	number_device integer not null
);

alter table devices owner to evraz;

create table flags
(
	id serial not null
		constraint flags_pk
			primary key,
	id_device uuid not null
		constraint flags_devices_id_device_fk
			references devices,
	time timestamp with time zone not null,
	type_flag smallint not null,
	positions real[] not null,
	image_path text not null,
	current_position integer,
	current_probability real not null
);

alter table flags owner to evraz;

create unique index flags_id_uindex
	on flags (id);

create index flags_positions_index
	on flags (positions);

create index flags_time_index
	on flags (time);

create table logs
(
	id bigserial not null
		constraint logs_pk
			primary key,
	time timestamp with time zone not null,
	level text not null,
	message text not null
);

alter table logs owner to evraz;

create unique index logs_id_uindex
	on logs (id);

create index logs_time_index
	on logs (time);

create function notify_flags_event() returns trigger
	language plpgsql
as $$
BEGIN
    -- Execute pg_notify(channel, notification)
    PERFORM pg_notify('flags', row_to_json(NEW)::text);

    -- Result is ignored since this is an AFTER trigger
    RETURN NULL;
END;

$$;

alter function notify_flags_event() owner to evraz;

create trigger products_notify_event
	after insert
	on flags
	for each row
	execute procedure notify_flags_event();

