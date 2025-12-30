package au.org.biodiversity.nsl
import java.sql.Timestamp

class ProfileItem {
    Instance instance
    TreeElement treeElement
    ProfileItem sourceProfileItem

    boolean isDraft
    Timestamp publishedDate

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
        treeElement nullable: true
        sourceProfileItem nullable: true

        updatedBy maxSize: 1000
        createdBy maxSize: 50
    }
}
