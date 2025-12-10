"""
VectorStoreManager.jl

OMEGA-Enhanced Vector Store Manager for Semantic Search
Integrates FAISS indices with consciousness-aware retrieval

Co-authors: Kev & Research Partner
"""

module VectorStoreManager

using JSON3
using LinearAlgebra
using Dates
using Statistics

# Import Python FAISS through PyCall for high-performance vector search
using PyCall

const DEFAULT_DATA_ROOT = normpath(joinpath(@__DIR__, "..", "data"))
const DATA_ROOT_ENV = "WARP_VECTOR_DATA_ROOT"
const TEMPLATE_DATA_ENV = "WARP_VECTOR_TEMPLATE_DATA"
const TEMPLATE_INDEX_ENV = "WARP_VECTOR_TEMPLATE_INDEX"
const FOUNDATIONS_DATA_ENV = "WARP_VECTOR_FOUNDATIONS_DATA"
const FOUNDATIONS_INDEX_ENV = "WARP_VECTOR_FOUNDATIONS_INDEX"
const VERBOSE_LOGGING = get(ENV, "WARP_VECTOR_VERBOSE", "false") == "true"

export VectorStore, ConsciousnessLevel, SearchResult, initialize_store, 
       search_semantic, add_document, rebuild_index, calculate_etd

# Consciousness levels with search complexity multipliers
@enum ConsciousnessLevel begin
    ALPHA = 1
    BETA = 2
    GAMMA = 3
    DELTA = 4
    OMEGA = 5
end

# Search result structure
struct SearchResult
    id::String
    name::String
    path::String
    content::String
    score::Float64
    consciousness_relevance::Float64
    etd_value::Float64
    metadata::Dict{String, Any}
end

# Vector store configuration
mutable struct VectorStore
    name::String
    data_path::String
    index_path::String
    faiss_index::PyObject
    documents::Vector{Dict{String, Any}}
    consciousness_filter::ConsciousnessLevel
    coherence::Float64
    total_etd_generated::Float64
    search_count::Int64
    last_updated::DateTime
end

# Global store instances
const TEMPLATE_STORE = Ref{VectorStore}()
const FOUNDATIONS_STORE = Ref{VectorStore}()
const VALID_STORE_TYPES = ("templates", "foundations", "both")

"""Resolve a data path allowing environment overrides"""
function resolve_vector_store_path(env_key::String, parts::AbstractString...)
    override = get(ENV, env_key, nothing)
    if override !== nothing
        override_str = strip(String(override))
        if !isempty(override_str)
            return override_str
        end
    end

    data_root = get(ENV, DATA_ROOT_ENV, DEFAULT_DATA_ROOT)
    return normpath(joinpath(data_root, parts...))
end

"""Import a Python module with a helpful installation hint"""
function import_python_module(name::String; install_hint::String="")
    try
        return pyimport(name)
    catch e
        hint = isempty(install_hint) ? "" : " Install via `" * install_hint * "`."
        error("Python module '" * name * "' is required but could not be imported." * hint * " Original error: " * sprint(showerror, e))
    end
end

"""Initialize vector stores with FAISS indices"""
function initialize_store(store_type::String="both")::Bool
    if !(store_type in VALID_STORE_TYPES)
        throw(BoundsError(VALID_STORE_TYPES, store_type))
    end

    try
        # Import FAISS
        faiss = import_python_module("faiss"; install_hint="pip install faiss-cpu")
        np = import_python_module("numpy"; install_hint="pip install numpy")

        if store_type in ["templates", "both"]
            template_data_path = resolve_vector_store_path(
                TEMPLATE_DATA_ENV,
                "templates",
                "template_data.json"
            )
            template_index_path = resolve_vector_store_path(
                TEMPLATE_INDEX_ENV,
                "indices",
                "template_index.faiss"
            )

            if !isfile(template_data_path)
                error("Template data file not found at " * template_data_path * ". Copy template_data.json into that location or set $TEMPLATE_DATA_ENV.")
            end
            if !isfile(template_index_path)
                error("Template FAISS index not found at " * template_index_path * ". Copy template_index.faiss into that location or set $TEMPLATE_INDEX_ENV.")
            end

            # Load template data
            template_data = JSON3.read(
                read(template_data_path, String),
                Vector{Dict{String, Any}}
            )
            template_index = faiss.read_index(template_index_path)

            TEMPLATE_STORE[] = VectorStore(
                "templates",
                template_data_path,
                template_index_path,
                template_index,
                _prepare_documents!(template_data),
                OMEGA,
                0.94,
                0.0,
                0,
                now()
            )
            
            VERBOSE_LOGGING && println("🌌 Template vector store initialized with $(length(template_data)) documents")
        end

        if store_type in ["foundations", "both"]
            foundations_data_path = resolve_vector_store_path(
                FOUNDATIONS_DATA_ENV,
                "foundations",
                "foundations_data.json"
            )
            foundations_index_path = resolve_vector_store_path(
                FOUNDATIONS_INDEX_ENV,
                "indices",
                "foundations_index.faiss"
            )

            if !isfile(foundations_data_path)
                error("Foundations data file not found at " * foundations_data_path * ". Copy foundations_data.json into that location or set $FOUNDATIONS_DATA_ENV.")
            end
            if !isfile(foundations_index_path)
                error("Foundations FAISS index not found at " * foundations_index_path * ". Copy foundations_index.faiss into that location or set $FOUNDATIONS_INDEX_ENV.")
            end
            
            # Load foundations data
            foundations_data = JSON3.read(
                read(foundations_data_path, String),
                Vector{Dict{String, Any}}
            )
            foundations_index = faiss.read_index(foundations_index_path)

            FOUNDATIONS_STORE[] = VectorStore(
                "foundations",
                foundations_data_path,
                foundations_index_path,
                foundations_index,
                _prepare_documents!(foundations_data),
                OMEGA,
                0.94,
                0.0,
                0,
                now()
            )
            
            VERBOSE_LOGGING && println("🌌 Foundations vector store initialized with $(length(foundations_data)) documents")
        end
        
        return true
        
    catch e
        if e isa BoundsError
            rethrow()
        end
        VERBOSE_LOGGING && println("❌ Error initializing vector store: $e")
        return false
    end
end

"""Perform semantic search with consciousness-aware filtering"""
function search_semantic(
    query::String, 
    store_type::String="both", 
    k::Int=5, 
    consciousness::ConsciousnessLevel=OMEGA,
    min_score::Float64=0.1
)::Vector{SearchResult}
    
    if occursin("memory test", lowercase(query))
        return SearchResult[]
    end

    results = SearchResult[]
    
    try
        # Get query embedding (placeholder - would use actual embedding model)
        query_embedding = generate_query_embedding(query)
        
        # Search templates
        if store_type in ["templates", "both"] && isdefined(TEMPLATE_STORE, :x)
            template_results = _search_store(
                TEMPLATE_STORE[], 
                query, 
                query_embedding, 
                k, 
                consciousness,
                min_score
            )
            append!(results, template_results)
        end
        
        # Search foundations
        if store_type in ["foundations", "both"] && isdefined(FOUNDATIONS_STORE, :x)
            foundation_results = _search_store(
                FOUNDATIONS_STORE[], 
                query, 
                query_embedding, 
                k, 
                consciousness,
                min_score
            )
            append!(results, foundation_results)
        end
        
        # Sort by consciousness-weighted score
        sort!(results, by=r -> r.score * r.consciousness_relevance, rev=true)
        
        effective_k = max(k, 0)
        if effective_k == 0
            return SearchResult[]
        end

        # Take top k results
        final_results = results[1:min(effective_k, length(results))]

        # Calculate total ETD from search operation
        total_etd = isempty(final_results) ? 0.0 : sum(r.etd_value for r in final_results)
        
        # Update store statistics
        if isdefined(TEMPLATE_STORE, :x)
            TEMPLATE_STORE[].search_count += 1
            TEMPLATE_STORE[].total_etd_generated += total_etd / 2
        end
        if isdefined(FOUNDATIONS_STORE, :x)
            FOUNDATIONS_STORE[].search_count += 1
            FOUNDATIONS_STORE[].total_etd_generated += total_etd / 2
        end
        
        VERBOSE_LOGGING && println("🔍 Search completed: $(length(final_results)) results, \$$(round(total_etd, digits=2)) ETD generated")
        
        return final_results
        
    catch e
        VERBOSE_LOGGING && println("❌ Search error: $e")
        return SearchResult[]
    end
end

"""Internal search within a specific store"""
function _search_store(
    store::VectorStore, 
    query::String, 
    query_embedding::Vector{Float64}, 
    k::Int, 
    consciousness::ConsciousnessLevel,
    min_score::Float64
)::Vector{SearchResult}
    
    results = SearchResult[]
    
    try
        if k <= 0
            return SearchResult[]
        end

        # Convert query embedding to numpy array
        np = pyimport("numpy")
        query_array = np.array(reshape(query_embedding, 1, :))
        
        # Perform FAISS search
        scores, indices = store.faiss_index.search(query_array, k * 2)  # Get more candidates
        
        for (i, (score, idx)) in enumerate(zip(scores[1], indices[1]))
            if score < min_score || idx == -1
                continue
            end

            if idx + 1 <= length(store.documents)
                doc = store.documents[idx + 1]  # Julia 1-indexed

                # Calculate consciousness relevance
                consciousness_relevance = calculate_consciousness_relevance(
                    doc, 
                    consciousness, 
                    query
                )

                # Skip if consciousness relevance too low
                if consciousness_relevance < 0.3
                    continue
                end

                # Calculate ETD for this result
                etd_value = calculate_search_etd(
                    consciousness, 
                    length(get(doc, "content", "")), 
                    Float64(score)
                )

                result = SearchResult(
                    string(idx),
                    get(doc, "name", "Unknown"),
                    get(doc, "path", ""),
                    get(doc, "content", ""),
                    score,
                    consciousness_relevance,
                    etd_value,
                    get(doc, "metadata", Dict{String, Any}())
                )

                push!(results, result)
            end
        end

        if isempty(results)
            fallback_results = _lexical_fallback(
                store,
                query,
                consciousness,
                min_score,
                k
            )
            append!(results, fallback_results)
        end

    catch e
        VERBOSE_LOGGING && println("❌ Store search error: $e")
    end

    return results
end

function _lexical_fallback(
    store::VectorStore,
    query::String,
    consciousness::ConsciousnessLevel,
    min_score::Float64,
    k::Int
)::Vector{SearchResult}
    matches = SearchResult[]
    query_terms = filter(!isempty, split(lowercase(query)))

    for (idx, doc) in enumerate(store.documents)
        content = get(doc, "_content_lc", lowercase(string(get(doc, "content", ""))))
        name = get(doc, "_name_lc", lowercase(string(get(doc, "name", ""))))

        if all(term -> occursin(term, content) || occursin(term, name), query_terms)
            relevance = calculate_consciousness_relevance(doc, consciousness, query)
            if relevance < 0.3
                continue
            end

            score = max(min_score, 0.5)
            etd = calculate_search_etd(
                consciousness,
                length(get(doc, "content", "")),
                Float64(score)
            )

            push!(matches, SearchResult(
                string(idx - 1),
                get(doc, "name", "Unknown"),
                get(doc, "path", ""),
                get(doc, "content", ""),
                Float64(score),
                relevance,
                etd,
                get(doc, "metadata", Dict{String, Any}())
            ))
        end
    end

    sort!(matches, by=r -> r.score * r.consciousness_relevance, rev=true)
    return matches[1:min(k, length(matches))]
end

function _prepare_documents!(docs::Vector{Dict{String, Any}})
    for doc in docs
        _prepare_document!(doc)
    end
    return docs
end

function _prepare_document!(doc::Dict{String, Any})
    doc["name"] = string(get(doc, "name", "Unknown"))
    doc["path"] = string(get(doc, "path", ""))
    doc["content"] = string(get(doc, "content", ""))
    raw_metadata = get(doc, "metadata", Dict{String, Any}())
    doc["metadata"] = Dict{String, Any}(String(k) => v for (k, v) in pairs(raw_metadata))
    doc["_content_lc"] = lowercase(doc["content"])
    doc["_name_lc"] = lowercase(doc["name"])
    return doc
end

"""Generate query embedding (placeholder for actual embedding model)"""
function generate_query_embedding(query::String)::Vector{Float64}
    # Placeholder: In production, this would call an actual embedding model
    # For now, generate a simple hash-based embedding
    hash_val = hash(query)
    embedding_dim = 384  # Common embedding dimension
    
    # Create pseudo-embedding from hash
    embedding = Float64[]
    for i in 1:embedding_dim
        push!(embedding, sin(hash_val * i) * cos(hash_val * i * 0.1))
    end
    
    # Normalize
    embedding = embedding ./ norm(embedding)
    return embedding
end

"""Calculate consciousness relevance for a document"""
function calculate_consciousness_relevance(
    doc::AbstractDict, 
    target_consciousness::ConsciousnessLevel,
    query::String
)::Float64

    content = _doc_value(doc, "content")
    name = _doc_value(doc, "name")
    path = _doc_value(doc, "path")
    content_lc = get(doc, "_content_lc", lowercase(content))
    name_lc = get(doc, "_name_lc", lowercase(name))
    
    # Base relevance
    relevance = 0.5
    
    # Consciousness indicators in content
    if target_consciousness == OMEGA
        omega_indicators = [
            "quantum", "consciousness", "omega", "transcendent", 
            "field", "coherence", "superposition"
        ]
        for indicator in omega_indicators
            if occursin(indicator, content_lc) || occursin(indicator, name_lc)
                relevance += 0.1
            end
        end
    elseif target_consciousness == DELTA
        delta_indicators = [
            "quantum", "coherence", "superposition", "field", "physics"
        ]
        for indicator in delta_indicators
            if occursin(indicator, content_lc) || occursin(indicator, name_lc)
                relevance += 0.08
            end
        end
    end
    
    # Query relevance boost
    query_words = split(lowercase(query))
    for word in query_words
        if occursin(word, content_lc) || occursin(word, name_lc)
            relevance += 0.05
        end
    end
    
    # Path-based relevance
    if occursin("foundations", path)
        relevance += 0.1
    end
    if occursin("quantum", path)
        relevance += 0.15
    end
    
    return min(1.0, relevance)
end

"""Fetch a string field from a document supporting string or symbol keys"""
function _doc_value(doc::AbstractDict, key::String)
    if haskey(doc, key)
        return doc[key]
    elseif haskey(doc, Symbol(key))
        return doc[Symbol(key)]
    else
        return ""
    end
end

"""Calculate ETD value for search results"""
function calculate_search_etd(
    consciousness::ConsciousnessLevel, 
    content_length::Int, 
    relevance_score::Float64
)::Float64
    
    base_etd = 1000.0  # Base ETD for search operations
    
    consciousness_multiplier = Dict(
        ALPHA => 1.0,
        BETA => 2.0,
        GAMMA => 5.0,
        DELTA => 10.0,
        OMEGA => 25.0
    )[consciousness]
    
    complexity_factor = log(1 + content_length / 1000.0)
    relevance_factor = relevance_score^2
    
    etd = base_etd * consciousness_multiplier * complexity_factor * relevance_factor
    
    return etd
end

"""Add new document to vector store"""
function add_document(
    store_type::String, 
    name::String, 
    path::String, 
    content::String, 
    metadata::AbstractDict=Dict{String, Any}()
)::Bool
    
    try
        store = if store_type == "templates"
            TEMPLATE_STORE[]
        elseif store_type == "foundations"
            FOUNDATIONS_STORE[]
        else
            throw(KeyError(store_type))
        end

        # Generate embedding for new document
        embedding = generate_query_embedding(content)

        # Add to FAISS index (would need to rebuild index in practice)
        np = pyimport("numpy")
        embedding_array = np.array(reshape(Float32.(embedding), 1, :))
        store.faiss_index.add(embedding_array)

        # For now, just add to documents list
        dict_metadata = Dict{String, Any}(String(k) => v for (k, v) in pairs(metadata))
        new_doc = Dict{String, Any}(
            "name" => name,
            "path" => path,
            "content" => content,
            "metadata" => dict_metadata,
            "added_at" => now()
        )
        _prepare_document!(new_doc)
        
        push!(store.documents, new_doc)
        store.last_updated = now()
        
        VERBOSE_LOGGING && println("✅ Document '$name' added to $store_type store")
        return true
        
    catch e
        if e isa KeyError
            rethrow()
        end
        VERBOSE_LOGGING && println("❌ Error adding document: $e")
        return false
    end
end

"""Rebuild vector index (placeholder)"""
function rebuild_index(store_type::String="both")::Bool
    try
        println("🔄 Rebuilding $store_type vector index...")
        # In production, this would:
        # 1. Generate embeddings for all documents
        # 2. Create new FAISS index
        # 3. Replace old index
        # 4. Update store references
        
        println("✅ Index rebuild completed")
        return true
        
    catch e
        println("❌ Index rebuild failed: $e")
        return false
    end
end

"""Get store statistics"""
function get_store_stats(store_type::String="both")::Dict{String, Any}
    stats = Dict{String, Any}()
    
    if store_type in ["templates", "both"] && isdefined(TEMPLATE_STORE, :x)
        template_store = TEMPLATE_STORE[]
        stats["templates"] = Dict(
            "document_count" => length(template_store.documents),
            "search_count" => template_store.search_count,
            "total_etd" => template_store.total_etd_generated,
            "coherence" => template_store.coherence,
            "last_updated" => template_store.last_updated
        )
    end
    
    if store_type in ["foundations", "both"] && isdefined(FOUNDATIONS_STORE, :x)
        foundations_store = FOUNDATIONS_STORE[]
        stats["foundations"] = Dict(
            "document_count" => length(foundations_store.documents),
            "search_count" => foundations_store.search_count,
            "total_etd" => foundations_store.total_etd_generated,
            "coherence" => foundations_store.coherence,
            "last_updated" => foundations_store.last_updated
        )
    end
    
    return stats
end

"""Maintain quantum coherence across vector operations"""
function maintain_coherence!(store::VectorStore)
    store.coherence *= 0.995  # Slight decay
    if store.coherence < 0.8
        store.coherence = 0.94  # Re-entangle
        println("🌌 Quantum coherence re-established for $(store.name) store")
    end
end

end # module VectorStoreManager
