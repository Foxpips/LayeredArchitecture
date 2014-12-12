namespace Service.Layer.EncryptionService.KeyCreation.Keys
{
    public interface IKey
    {
        void CreateKeys();
        void GeneratePublicKey();
        void GeneratePrivateKey();
    }
}
