init()
{
    prestigeRankList = StrTok( "rank_prestige6;rank_prestige8;rank_prestige9;rank_prestige10", ";" );

    for( i = 0; i < prestigeRankList.size; i++ )
    {
        level.prestigeicons[ i + 1 ] = prestigeRankList[i];
        PreCacheStatusIcon( prestigeRankList[i] );
        PreCacheShader( prestigeRankList[i] );
    }

    thread novo\_events::addConnectEvent( ::PrestigeSettings );
}

PrestigeSettings()
{
    self thread Prestige();
}

Prestige()
{
    self endon( "disconnect" );

    wait .05;
    while( self.pers[ "rank" ] < 54 || self getStat( 634 ) == 0)
        wait 5;

    if( self getStat(634) > 7 ) // ** Bugfix
        self setStat( 634, 7 );

    self thread StatusIcon();

    if( self.pers[ "rank" ] == 54 && self getStat( 634 ) == 7 && self getStat( 635 ) == 255 )
        return;
}

StatusIcon()
{
    self endon( "disconnect" );
    self setRank( int( self getStat( 635 ) / 255 * 54 ), 0 );

    for(;;)
    {
        if( !isDefined( self ) || !isDefined( self.statusicon ) || self getStat( 635 ) == 0 )
            return;

        rank = int( self getStat( 635 ) / 255 * 54 );

        if( isDefined( self.statusicon ) && self.statusicon == "" )
            self.statusicon = self getPrestigeIcon();

        self common_scripts\utility::waittill_any( "disconnect", "update_score", "spawned_player" );
        waittillframeend;

        if( int( self getStat( 635 ) / 255 * 54 ) != rank)
        {
            self setRank( rank, 0 );
            self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
        }
    }
}

getPrestigeIcon()
{
    return level.prestigeicons[ self getStat( 634 ) ];
}