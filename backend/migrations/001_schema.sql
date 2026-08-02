CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_eligibility"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claimId" TEXT NOT NULL,
  "data_serviceType" TEXT NOT NULL,
  "data_serviceDate" DATE NOT NULL,
  "data_eligibilityRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_eligibility_due ON "op_eligibility"(due_date);

CREATE TABLE IF NOT EXISTS "op_open_negotiation"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claimId" TEXT NOT NULL,
  "data_initiationDate" DATE NOT NULL,
  "data_initialOffer" NUMERIC(16,2) NOT NULL,
  "data_negotiationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_open_negotiation_due ON "op_open_negotiation"(due_date);

CREATE TABLE IF NOT EXISTS "op_qpa"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claimId" TEXT NOT NULL,
  "data_qpaAmount" NUMERIC(16,2) NOT NULL,
  "data_geographicRegion" TEXT NOT NULL,
  "data_qpaConcerns" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_qpa_due ON "op_qpa"(due_date);

CREATE TABLE IF NOT EXISTS "op_batched_dispute"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_batchId" TEXT NOT NULL,
  "data_claimCount" NUMERIC(16,2) NOT NULL,
  "data_disputedAmount" NUMERIC(16,2) NOT NULL,
  "data_batchingRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_batched_dispute_due ON "op_batched_dispute"(due_date);

CREATE TABLE IF NOT EXISTS "op_offer_strategy"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_disputeId" TEXT NOT NULL,
  "data_qpaAmount" NUMERIC(16,2) NOT NULL,
  "data_proposedOffer" NUMERIC(16,2) NOT NULL,
  "data_offerRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_offer_strategy_due ON "op_offer_strategy"(due_date);

CREATE TABLE IF NOT EXISTS "op_gateway"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_disputeId" TEXT NOT NULL,
  "data_filingDeadline" DATE NOT NULL,
  "data_feeAmount" NUMERIC(16,2) NOT NULL,
  "data_filingNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_gateway_due ON "op_gateway"(due_date);

CREATE TABLE IF NOT EXISTS "op_determination"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_disputeId" TEXT NOT NULL,
  "data_determinationDate" DATE NOT NULL,
  "data_determinedAmount" NUMERIC(16,2) NOT NULL,
  "data_paymentNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_determination_due ON "op_determination"(due_date);

CREATE TABLE IF NOT EXISTS "op_portfolio"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_period" TEXT NOT NULL,
  "data_disputeCount" NUMERIC(16,2) NOT NULL,
  "data_winRate" NUMERIC(16,2) NOT NULL,
  "data_portfolioNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_portfolio_due ON "op_portfolio"(due_date);

CREATE TABLE IF NOT EXISTS "op_payer_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_payer" TEXT NOT NULL,
  "data_plan" TEXT NOT NULL,
  "data_network" TEXT NOT NULL,
  "data_idrContact" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_payer_register_due ON "op_payer_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_npi" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_state" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_register_due ON "op_provider_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_idr_entity_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_idrEntity" TEXT NOT NULL,
  "data_fee" NUMERIC(16,2) NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_status" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_idr_entity_register_due ON "op_idr_entity_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_deadline_rule_library"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_event" TEXT NOT NULL,
  "data_days" NUMERIC(16,2) NOT NULL,
  "data_dayType" TEXT NOT NULL,
  "data_evidence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_deadline_rule_library_due ON "op_deadline_rule_library"(due_date);
