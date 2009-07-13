package couk.psyked.air
{
	public class ApplicationConfigStorageType
	{
		public static const ENCRYPTED_STORE:String = "encryptedLocalStore";
		public static const NORMAL:String = "userLocalStorage";
		//public static const DOCUMENTS_DIRECTORY:String = "userDocuments";
		// (i'm thinking installation directory makes the settings apply to the machine in general, and not just specific user accounts)
		//public static const INSTALLATION_DIRECTORY:String = "installationDirectory";
		
		public function ApplicationConfigStorageType()
		{
		}

	}
}