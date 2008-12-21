cdef extern from *:
    ctypedef long size_t

cdef extern from "errno.h":
    int errno

cdef extern from "string.h":
    char * strerror(int errnum)
    char * strncpy(char *s1, char *s2, size_t n)

cdef extern from "netinet/in.h":
    struct in_addr:
        int s_addr
    struct sockaddr_in:
        short sin_family
        unsigned short sin_port
        in_addr sin_addr
        char sin_zero[8]

cdef extern from "afs/stds.h":
    ctypedef long afs_int32

cdef extern from "afs/dirpath.h":
    char * AFSDIR_CLIENT_ETC_DIRPATH

cdef extern from "afs/cellconfig.h":
    enum:
        MAXCELLCHARS
        MAXHOSTSPERCELL
        MAXHOSTCHARS
    
    # We just pass afsconf_dir structs around to other AFS functions,
    # so this can be treated as opaque
    struct afsconf_dir:
        pass
    
    # For afsconf_cell, on the other hand, we care about everything
    struct afsconf_cell:
        char name[MAXCELLCHARS]
        short numServers
        short flags
        sockaddr_in hostAddr[MAXHOSTSPERCELL]
        char hostName[MAXHOSTSPERCELL][MAXHOSTCHARS]
        char *linkedCell
        int timeout
     
    afsconf_dir *afsconf_Open(char *adir)
    int afsconf_GetCellInfo(afsconf_dir *adir,
                            char *acellName,
                            char *aservice,
                            afsconf_cell *acellInfo)

cdef extern from "ubik.h":
    enum:
        MAXSERVERS
    
    # ubik_client is an opaque struct, so we don't care about its members
    struct ubik_client:
        pass

cdef extern from "rx/rx.h":
    int rx_Init(int port)
    void rx_Finalize()

cdef extern from *:
    struct ktc_encryptionKey:
        pass

cdef extern from "rx/rxkad.h":
    ctypedef char rxkad_level
    
    enum:
        MAXKTCNAMELEN
        MAXKTCREALMLEN
    
    enum:
        rxkad_clear
        rxkad_crypt
    
    struct ktc_principal:
        char name[MAXKTCNAMELEN]
        char instance[MAXKTCNAMELEN]
        char cell[MAXKTCREALMLEN]
    
    struct rx_securityClass:
        pass
    
    rx_securityClass *rxkad_NewClientSecurityObject(rxkad_level level,
                                                    ktc_encryptionKey *sessionKey,
                                                    afs_int32 kvno,
                                                    int ticketLen,
                                                    char *ticket)
    rx_securityClass *rxnull_NewClientSecurityObject()
    
    int rxs_Release(rx_securityClass *aobj)

cdef extern from "afs/auth.h":
    enum:
        MAXKTCTICKETLEN
    
    struct ktc_token:
        ktc_encryptionKey sessionKey
        short kvno
        int ticketLen
        char ticket[MAXKTCTICKETLEN]
    
    int ktc_GetToken(ktc_principal *server,
                     ktc_token *token,
                     int tokenLen,
                     ktc_principal *client)

cdef extern from "afs/com_err.h":
    char * error_message(int)