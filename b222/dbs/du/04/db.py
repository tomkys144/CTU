# coding: utf-8
import sys

from sqlalchemy import BigInteger, CHAR, CheckConstraint, Column, ForeignKey, Integer, SmallInteger, Text, text
from sqlalchemy.dialects.postgresql import CIDR, INET, MACADDR, UUID
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

from faker import Faker

Base = declarative_base()
metadata = Base.metadata

faker  = Faker()

class Interface(Base):
    __tablename__ = 'interfaces'
    __table_args__ = (
        CheckConstraint("type = ANY (ARRAY['ethernet'::text, 'radio'::text, 'sfp+'::text, 'qsfp+'::text])"),
    )

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('interfaces_id_seq'::regclass)"))
    name = Column(Text, nullable=False)
    type = Column(Text, nullable=False, server_default=text("'ethernet'::text"))
    mac = Column(MACADDR, nullable=False)


class Model(Base):
    __tablename__ = 'models'
    __table_args__ = (
        CheckConstraint("typegroup = ANY (ARRAY['computer'::text, 'ap'::text, 'core'::text])"),
    )

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('models_id_seq'::regclass)"))
    name = Column(Text, nullable=False)
    manufacturer = Column(Text, nullable=False)
    typegroup = Column(Text, nullable=False, server_default=text("'computer'::text"))
    devicetype = Column(Text)


class Usergroup(Base):
    __tablename__ = 'usergroups'

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('usergroups_id_seq'::regclass)"))
    name = Column(Text, nullable=False, unique=True)


class User(Base):
    __tablename__ = 'users'

    uid = Column(UUID, primary_key=True)
    username = Column(Text, nullable=False, unique=True)


class Vlan(Base):
    __tablename__ = 'vlans'
    __table_args__ = (
        CheckConstraint('(vid > 0) AND (vid < 4095)'),
    )

    vid = Column(SmallInteger, primary_key=True)
    name = Column(Text, nullable=False)
    ipv4range = Column(CIDR, nullable=False)
    ipv6range = Column(CIDR, nullable=False)


class Device(Base):
    __tablename__ = 'devices'

    invno = Column(CHAR(6), primary_key=True)
    location = Column(CHAR(3), nullable=False)
    hostname = Column(Text)
    model = Column(ForeignKey('models.id', ondelete='SET NULL'), nullable=False, server_default=text("nextval('devices_model_seq'::regclass)"))
    os = Column(Text)

    model1 = relationship('Model')


class Hwconnection(Base):
    __tablename__ = 'hwconnections'

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('hwconnections_id_seq'::regclass)"))
    source = Column(ForeignKey('interfaces.id', ondelete='CASCADE'), nullable=False, server_default=text("nextval('hwconnections_source_seq'::regclass)"))
    target = Column(ForeignKey('interfaces.id', ondelete='CASCADE'), nullable=False, server_default=text("nextval('hwconnections_target_seq'::regclass)"))

    interface = relationship('Interface', primaryjoin='Hwconnection.source == Interface.id')
    interface1 = relationship('Interface', primaryjoin='Hwconnection.target == Interface.id')


class Swconnection(Base):
    __tablename__ = 'swconnections'
    __table_args__ = (
        CheckConstraint('(ipv4 IS NOT NULL) OR (ipv6 IS NOT NULL)'),
    )

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('swconnections_id_seq'::regclass)"))
    interface = Column(ForeignKey('interfaces.id', ondelete='CASCADE'), nullable=False, server_default=text("nextval('swconnections_interface_seq'::regclass)"))
    ipv4 = Column(INET)
    ipv6 = Column(INET)
    vlan = Column(ForeignKey('vlans.vid', ondelete='CASCADE'), nullable=False)

    interface1 = relationship('Interface')
    vlan1 = relationship('Vlan')


class Usergrouprelation(Base):
    __tablename__ = 'usergrouprelations'

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('usergrouprelations_id_seq'::regclass)"))
    usergroup = Column(ForeignKey('usergroups.id', ondelete='CASCADE'), nullable=False, server_default=text("nextval('usergrouprelations_usergroup_seq'::regclass)"))
    userid = Column(ForeignKey('users.uid', ondelete='CASCADE'), nullable=False)

    usergroup1 = relationship('Usergroup')
    user = relationship('User')


class Wlan(Base):
    __tablename__ = 'wlans'

    ssid = Column(Text, primary_key=True)
    vlan = Column(ForeignKey('vlans.vid', ondelete='SET NULL'), nullable=False)

    vlan1 = relationship('Vlan')


class Computeracces(Base):
    __tablename__ = 'computeraccess'

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('computeraccess_id_seq'::regclass)"))
    userid = Column(ForeignKey('users.uid', ondelete='CASCADE'), nullable=False)
    computer = Column(ForeignKey('devices.invno', ondelete='CASCADE'), nullable=False)

    device = relationship('Device')
    user = relationship('User')


class Deviceinterface(Base):
    __tablename__ = 'deviceinterfaces'

    id = Column(BigInteger, primary_key=True, server_default=text("nextval('deviceinterfaces_id_seq'::regclass)"))
    device = Column(ForeignKey('devices.invno', ondelete='CASCADE'), nullable=False)
    interface = Column(ForeignKey('interfaces.id', ondelete='CASCADE'), nullable=False, server_default=text("nextval('deviceinterfaces_interface_seq'::regclass)"))

    device1 = relationship('Device')
    interface1 = relationship('Interface')


class Wlanemit(Base):
    __tablename__ = 'wlanemits'
    __table_args__ = (
        CheckConstraint('channel2 = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])'),
        CheckConstraint('channel5 = ANY (ARRAY[32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 68, 96, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128, 132, 134, 136, 138, 140, 142, 144, 149, 151, 153, 155, 157, 159, 161, 165, 167, 169, 171, 173])'),
        CheckConstraint('channelwidth2 = ANY (ARRAY[20, 40])'),
        CheckConstraint('channelwidth5 = ANY (ARRAY[20, 40, 80])')
    )

    id = Column(Integer, primary_key=True, server_default=text("nextval('wlanemits_id_seq'::regclass)"))
    wlan = Column(ForeignKey('wlans.ssid', ondelete='CASCADE'), nullable=False)
    device = Column(ForeignKey('devices.invno', ondelete='CASCADE'), nullable=False)
    channel2 = Column(SmallInteger, nullable=False)
    channelwidth2 = Column(SmallInteger, nullable=False)
    channel5 = Column(SmallInteger, nullable=False)
    channelwidth5 = Column(SmallInteger, nullable=False)

    device1 = relationship('Device')
    wlan1 = relationship('Wlan')