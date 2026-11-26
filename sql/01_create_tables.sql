-- Table: analytics.orders

-- DROP TABLE IF EXISTS analytics.orders;

CREATE TABLE IF NOT EXISTS analytics.orders
(
    order_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    customer_id character varying(50) COLLATE pg_catalog."default",
    order_status character varying(30) COLLATE pg_catalog."default",
    order_purchase_timestamp timestamp without time zone,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone,
    CONSTRAINT orders_pkey PRIMARY KEY (order_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS analytics.orders
    OWNER to postgres;