﻿namespace SqlAgentUIRunner.Infrastructure.Mappers
{
    public interface IMapFrom
    {
    }

    public interface IMapFrom<T> : IMapFrom
    {
    }

    public interface IMapFrom<T, T2> : IMapFrom
    {
    }

    public interface IMapFrom<T, T2, T3> : IMapFrom
    {
    }
}