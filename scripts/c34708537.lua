-- code: 3470853737
-- Necroworld Vampire
local s, id = GetID()
function s.initial_effect( c )
	-- Search Zombie World
	local e1 = Effect.CreateEffect( c )
	e1:SetDescription( aux.Stringid( id, 0 ) )
	e1:SetCategory( CATEGORY_SEARCH )
	e1:SetType( EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O )
	e1:SetProperty( EFFECT_FLAG_DELAY )
	e1:SetCode( EVENT_SPSUMMON_SUCCESS )
	e1:SetCountLimit( 1, { id, 0 } )
	e1:SetCondition( s.search_con )
	e1:SetCost( s.search_cost )
	e1:SetTarget( s.search_tg )
	e1:SetOperation( s.search_op )
	c:RegisterEffect( e1 )

	-- Special summon from GY
	local e2 = Effect.CreateEffect( c )
	e2:SetDescription( aux.Stringid( id, 1 ) )
	e2:SetCategory( CATEGORY_SPECIAL_SUMMON )
	e2:SetType( EFFECT_TYPE_IGNITION )
	e2:SetRange( LOCATION_GRAVE )
	e2:SetCountLimit( 1, { id, 1 } )
	e2:SetCost( s.revive_cost )
	e2:SetTarget( s.revive_tg )
	e2:SetOperation( s.revive_op )
	c:RegisterEffect( e2 )
end

s.listed_names = { id, 4064256 }
s.listed_series = { 0x8e }

function s.search_filter( c, tp )
	return c:IsCode( 4064256 ) and (c:GetActivateEffect():IsActivatable( tp, true, true ) or c:IsAbleToHand())
end

function s.search_con( e, tp, eg, ep, ev, re, r, rp )
	return Duel.IsExistingMatchingCard(s.search_filter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, tp)
end

function s.search_cost( e, tp, eg, ep, ev, re, r, rp, chk )
	if chk == 0 then
		return Duel.CheckLPCost( tp, 500 )
	end

	Duel.PayLPCost( tp, 500 )
end

function s.search_tg( e, tp, eg, ep, ev, re, r, rp, chk )
	if chk == 0 then
		return Duel.IsExistingMatchingCard( s.search_filter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, tp )
	end

	Duel.SetOperationInfo( 0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE )
end

function s.search_op( e, tp, eg, ep, ev, re, r, rp )
	Duel.Hint( HINT_SELECTMSG, tp, aux.Stringid( id, 2 ) )
	local g = Duel.SelectMatchingCard( tp, s.search_filter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, tp )

	if #g < 0 then
		return
	end

	local tc = g:GetFirst()

	aux.ToHandOrElse( tc, tp, function( c )
		return tc:GetActivateEffect():IsActivatable( tp, true, true )
	end, function( c )
		Duel.ActivateFieldSpell( tc, e, tp, eg, ep, ev, re, r, rp )
	end, aux.Stringid( id, 3 ) )
end

function s.revive_filter( c, tp )
	return c:IsSetCard( 0x8e ) and (c:IsLocation( LOCATION_HAND ) or (c:IsFaceup() and c:IsLocation( LOCATION_ONFIELD )))
		       and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount( tp, c ) > 0
end

function s.revive_cost( e, tp, eg, ep, ev, re, r, rp, chk )
	if chk == 0 then
		return Duel.IsExistingMatchingCard( s.revive_filter, tp, LOCATION_HAND + LOCATION_ONFIELD, 0, 1, nil, tp )
	end

	Duel.Hint( HINT_SELECTMSG, tp, HINTMSG_TOGRAVE )
	local g = Duel.SelectMatchingCard( tp, s.revive_filter, tp, LOCATION_ONFIELD + LOCATION_HAND, 0, 1, 1, nil, tp )
	Duel.SendtoGrave( g, REASON_COST )
end

function s.revive_tg( e, tp, eg, ep, ev, re, r, rp, chk )
	local c = e:GetHandler()

	if chk == 0 then
		return c:IsCanBeSpecialSummoned( e, SUMMON_TYPE_SPECIAL, tp, false, false )
	end

	Duel.SetOperationInfo( 0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0 )
end

function s.revive_op( e, tp, eg, ep, ev, re, r, rp )
	local c = e:GetHandler()

	if c:IsRelateToEffect( e ) and Duel.SpecialSummon( c, 0, tp, tp, false, false, POS_FACEUP ) > 0 then
		-- Banish it if it leaves the field
		local e1 = Effect.CreateEffect( c )
		e1:SetDescription( 3300 )
		e1:SetType( EFFECT_TYPE_SINGLE )
		e1:SetCode( EFFECT_LEAVE_FIELD_REDIRECT )
		e1:SetProperty( EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CLIENT_HINT )
		e1:SetReset( RESET_EVENT + RESETS_REDIRECT )
		e1:SetValue( LOCATION_REMOVED )
		c:RegisterEffect( e1, true )
	end
end
