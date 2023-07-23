-- code: 34708539
-- Vampire Coffin
local s, id = GetID()
function s.initial_effect( c )
	-- activate
	local e1 = Effect.CreateEffect( c )
	e1:SetCategory( CATEGORY_TODECK )
	e1:SetType( EFFECT_TYPE_ACTIVATE )
	e1:SetCode( EVENT_FREE_CHAIN )
	e1:SetTarget( s.target )
	e1:SetOperation( s.activate )
	c:RegisterEffect( e1 )
end

s.listed_series = { 0x8e }

function s.filter( c )
	return c:IsSetCard( 0x8e ) and c:IsAbleToDeck()
end

function s.target( e, tp, eg, ep, ev, re, r, rp, chk, chkc )
	if chk == 0 then
		return Duel.IsExistingMatchingCard( s.filter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil )
	end

	if chkc then
		return chkc:IsAbleToDeck()
	end

	Duel.Hint( HINT_SELECTMSG, tp, HINTMSG_TARGET )
	local g = Duel.SelectTarget( tp, s.filter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil )
	Duel.SetTargetCard( g )
	Duel.SetOperationInfo( 0, CATEGORY_TODECK, g, 1, tp, 0 )
end

function s.activate( e, tp, eg, ep, ev, re, r, rp )
	local g = Duel.GetTargetCards( e )
	if not g or #g <= 0 then
		return
	end

	Duel.SendtoDeck( g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT )
end
