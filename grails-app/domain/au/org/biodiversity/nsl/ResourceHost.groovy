package au.org.biodiversity.nsl

import java.sql.Timestamp

class ResourceHost {
    String name
    String description
    String resolvingUrl
    int sortOrder
    Boolean forReference
    Boolean forName
    Boolean forInstance
    String rdfId

    String updatedBy
    Timestamp updatedAt
    String createdBy
    Timestamp createdAt

    static mapping = {
        id generator: 'sequence', params: [sequence_name: 'nsl_global_seq'], defaultValue: "nextval('nsl_global_seq')"
        version column: 'lock_version', defaultValue: "0"
        updatedAt sqlType: 'timestamp with time zone'
        createdAt sqlType: 'timestamp with time zone'
    }

    static constraints = {
        forReference nullable: true
        forName nullable: true
        forInstance nullable: true

        updatedBy maxSize: 1000
        createdBy maxSize: 50
    }
}
