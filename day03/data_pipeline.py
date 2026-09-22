class DataPipeline:
    def __init__(self, source, destination):
        self.source = source
        self.destination = destination
        self.status = f"{self.source} -> {self.destination} Stopped"
    def get_status (self):
        print(self.status)

    def run(self):
        self.status = f"{self.source} -> {self.destination} Running"
        self.get_status()

    def stop(self):
        self.status = f"{self.source} -> {self.destination} Stopped"
        self.get_status()
dataPipeline1 = DataPipeline("MySQL","PostgreSQL")
dataPipeline2 = DataPipeline("Redis","MySQL")
dataPipeline3 = DataPipeline("MySQL","Postman")

dataPipeline1.get_status()
dataPipeline2.run()
dataPipeline3.run()
dataPipeline2.stop()
dataPipeline3.stop()
    

    
