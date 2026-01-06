package au.org.biodiversity.nsl

import java.sql.Timestamp

class ReferenceResource {
    Resource resource
    Reference reference
    String value
    String note
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
        value nullable: true
        note nullable: true

        updatedBy maxSize: 1000
        createdBy maxSize: 50
    }
}
