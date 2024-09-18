import uuid
from sqlalchemy import create_engine, MetaData, \
    Column, Integer, Numeric, String, Date, Table, ForeignKey
from faker import Faker
import sys
import random

engine = create_engine(
    "postgresql://kyseltom:Dracijezdec144@slon.felk.cvut.cz:5432/kyseltom"
)

metadata = MetaData()

faker = Faker()

with engine.connect() as conn:
    metadata.reflect(conn)

devices = metadata.tables['devices']
users = metadata.tables['users']
usergrouprelations = metadata.tables['usergrouprelations']
interfaces = metadata.tables['interfaces']
deviceInterfaces = metadata.tables['deviceinterfaces']
HWConnections = metadata.tables['hwconnections']
SWConnections = metadata.tables['swconnections']

class GenerateData:
    def __init__(self, table, records):
        self.table = table
        self.num_records = records

    def create_data(self):
        with engine.begin() as conn:
            if self.table == 'devices':
                for i in range(self.num_records):
                    print(i)
                    model = random.randint(1, 11)
                    insert_stmt = devices.insert().values(
                        invno=str(i+10).rjust(6, '0'),
                        location=self.createRoom(random.randint(0, 399)),
                        hostname=str(faker.first_name()).lower(),
                        model=model,
                        os=self.createOS(model)
                    )
                    conn.execute(insert_stmt)

            elif self.table == 'users':
                for i in range(self.num_records):
                    print(i)
                    uid = str(uuid.uuid4())
                    insert_stmt = users.insert().values(
                        uid = uid,
                        username = faker.user_name()
                    )
                    insert2 = usergrouprelations.insert().values(
                        usergroup = self.chooseGroup(i),
                        userid = uid
                    )
                    conn.execute(insert_stmt)
                    conn.execute(insert2)

            elif self.table == 'interfaces':
                names = ['eth0', 'wlan0', 'sfp0', 'qsfp0']
                types = ['ethernet', 'radio', 'sfp+', 'qsfp+']
                vlans = [100, 300, 200, 200]
                id = 1
                for i in range(self.num_records):
                    print(i)
                    for j in range(self.chooseType(i)):
                        insert_interface = interfaces.insert().values(
                            name = names[j],
                            type = types[j],
                            mac = faker.mac_address()
                        )
                        insert_device = deviceInterfaces.insert().values(
                            device = str(i).rjust(6, '0'),
                            interface = id
                        )

                        insert_sw = SWConnections.insert().values(
                            interface = id,
                            ipv4 = faker.ipv4_private(),
                            ipv6 = faker.ipv6(network=True),
                            vlan = vlans[j]
                        )

                        conn.execute(insert_interface)
                        conn.execute(insert_device)
                        conn.execute(insert_sw)

                        id += 1

    def chooseGroup(self, i):
        if not i % 30:
            return 3
        if not i % 10:
            return 1
        return 2

    def chooseType(self, i):
        if not i % 30:
            return 3
        if not i % 10:
            return 2
        return 1
    def createRoom(self, number):
        if number < 10:
            return 'P0' + str(number)

        if number < 100:
            return 'P' + str(number)

        if number >= 310:
            return 'S' + str(number - 300)

        if number >= 300:
            return 'S0' + str(number - 300)

        return str(number)

    def createOS(self, model):
        if model == 9 or model == 11:
            return "Win 11"
        if model == 10:
            return "Win 10"
        if model <= 2:
            return "Router OS"
        if model >= 6:
            return "OpenWRT"
        return ""

if __name__ == "__main__":
    generate_data = GenerateData('interfaces', 100)
    generate_data.create_data()