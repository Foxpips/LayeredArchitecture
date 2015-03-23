namespace Business.Logic.Layer.Interfaces.AutoMapper
{
    public interface IMapTo
    {
    }

    public interface IMapTo<T> : IMapTo
    {
    }

    public interface IMapTo<T, T2> : IMapTo
    {
    }

    public interface IMapTo<T, T2, T3> : IMapTo
    {
    }
}