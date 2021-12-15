PROJECTS = crc32_0032 \
           crc32_0064 \
           crc32_0128 \
           crc32_0256 \
           crc32_0512 \
           crc32_1024 \
           crc32_2048 \
           crc32_4096 \
           $(ENDLIST)

build:
	$(foreach project, $(PROJECTS), make -C $(project) build;)

sources:
	$(foreach project, $(PROJECTS), make -C $(project) sources;)

clean:
	$(foreach project, $(PROJECTS), make -C $(project) clean;)

